{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Spock.Safe (params, runSpock, spockT, text, post, root)
import Control.Monad.IO.Class (liftIO)
import Data.Maybe (fromMaybe)
import System.Environment (lookupEnv)

import Heyleo.Utils.Params (makeParams)
import Heyleo.Slack.SlashMessage (fromParams, SlashMessage(..))

main :: IO ()
main = do
    maybePort <- lookupEnv "PORT"
    port <- return . read $ fromMaybe "8080" maybePort
    runSpock port . spockT id $ do
      post root $ do
        ps <- params
        hash <- return $ makeParams ps
        msg <- return $ fromParams hash
        liftIO . putStrLn $ msgText msg
        text "Added your message to Leo's board!"
