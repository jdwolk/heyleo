module Heyleo.Slack.SlashTest where

import qualified Data.ByteString.Lazy as BS
import Data.Aeson (decode)

import Heyleo.Slack.SlashMessage

takeJSONFile :: FilePath -> IO BS.ByteString
takeJSONFile filePath = do
  jsonData <- BS.readFile filePath
  return jsonData

printMessage :: BS.ByteString -> IO ()
printMessage messageJSON = do
  maybeMessage <- return $ decode messageJSON :: IO (Maybe SlashMessage)
  messageString <- case maybeMessage of
    Just message -> return $ show message
    Nothing -> return "Couldn't parse message"
  putStrLn messageString

printMessageFromFile :: FilePath -> IO ()
printMessageFromFile jsonFile = do
  messageJSON <- takeJSONFile jsonFile
  printMessage messageJSON

doShit :: IO ()
doShit = do
  let jsonFile = "/Users/jordaniel/projects/philosophie/internal/heyleo/data.json"
  printMessageFromFile jsonFile

