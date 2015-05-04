{-# LANGUAGE OverloadedStrings #-}

module Heyleo.Slack.SlashCommand (
  SlashCommand(..)
) where

import Data.Aeson (withText, FromJSON, parseJSON)
import Data.Text (unpack)

data SlashCommand = HeyleoCmd | OtherCmd deriving (Show)

instance FromJSON SlashCommand where
  parseJSON = withText "slashCommand" $ \s -> do
    case unpack s of
      "/heyleo" -> return HeyleoCmd
      _         -> return OtherCmd
