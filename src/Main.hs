{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Spock.Safe (params, runSpock, spockT, text, post, get, root)
import Control.Monad.IO.Class (liftIO)
import Data.Maybe (fromMaybe)
import System.Environment (lookupEnv, getEnv)
import System.Directory (doesFileExist)
import qualified Configuration.Dotenv as Dotenv
import qualified Data.Text as T

import Heyleo.Data.Params (makeParams)
import Heyleo.Slack.SlashMessage (fromParams)
import Heyleo.Trello.Api (TrelloConfig(..), createCard)

configFromEnv :: IO TrelloConfig
configFromEnv = do
  key  <- getEnv "TRELLO_KEY"
  token<- getEnv "TRELLO_TOKEN"
  bID  <- getEnv "BOARD_ID"
  lID  <- getEnv "LIST_ID"
  mIDs <- getEnv "MEMBER_IDS"
  putStrLn "Loaded Trello config from environment"
  return TrelloConfig {
    trelloKey     = key
    , trelloToken = token
    , boardID     = bID
    , listID      = lID
    , memberIDs   = mIDs
  }

handleCreate :: Either String String -> String
handleCreate (Right _)  = "Added your message to Leo's board!"
handleCreate (Left s)   = s

main :: IO ()
main = do
    exists    <- doesFileExist "./.env"
    _         <- if exists then Dotenv.loadFile False "./.env" else putStrLn "No .env file found"
    maybePort <- lookupEnv "PORT"
    port      <- return . read $ fromMaybe "8080" $ maybePort
    trelloCfg <- configFromEnv
    runSpock port . spockT id $ do
      get root $ do
        text "Heyleo server is runnning"
      post root $ do
        ps        <- params
        hash      <- return $ makeParams ps
        msg       <- return $ fromParams hash
        result    <- liftIO $ createCard trelloCfg msg
        resultTxt <- return $ handleCreate result
        liftIO $ putStrLn resultTxt
        text $ T.pack resultTxt

