{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Main where

import Network.Wai.Middleware.Cors
import Web.Scotty
import Data.Aeson (FromJSON, ToJSON)
import GHC.Generics

import qualified Data.Text.Lazy as L

main :: IO ()
main = do -- IO Monad
  putStrLn "Startin Server at 4711 ..."
  scotty 4711 $ do -- ScottyM Monad
    middleware $ cors (const $ Just appCorsResourcePolicy)
    get "/" $ do  -- ActionM
      text "Server is up. There currently exists /book (get) /saveBook (post)"
    get "/book" $ json allBooks
    post "/saveBook" $ do
      book <- jsonData :: ActionM Book
      text $ L.pack ("Book saved was: " ++ (title book) ++ "!")

-- allowCors :: Middleware
-- allowCors = cors (const $ Just appCorsResourcePolicy)

appCorsResourcePolicy :: CorsResourcePolicy
appCorsResourcePolicy =
    simpleCorsResourcePolicy
        { corsMethods = ["GET", "POST"]
        , corsRequestHeaders = ["Authorization", "Content-Type"]
        }


allBooks :: [Book]
allBooks = [b1 , b2]

b1 :: Book
b1 = Book "1" "TestBog" "Hr. Tester" "123" "Test Beskrivelse"

b2 :: Book
b2 = Book "2" "TestBog 2" "Hr. Tester" "123" "Test Beskrivelse"


data Book = Book
  { isbn :: String
  , title :: String
  , author :: String
  , pages :: String
  , description :: String
  } deriving (Show, Generic)

instance ToJSON Book
instance FromJSON Book




