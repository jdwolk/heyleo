{-# LANGUAGE OverloadedStrings #-}

module Heyleo.Slack.SlashMessage where

import Data.Aeson (withObject, FromJSON, (.:), parseJSON, decode)
import Control.Applicative ((<$>), (<*>))

import Heyleo.Slack.SlashCommand

data SlashMessage = SlashMessage {
    token        :: String -- 'dslkfjDSLKJdflk123',
  , teamID       :: String -- 'TSH34HJD',
  , teamDomain   :: String -- 'philosophie',
  , channelID    :: String -- 'D03BHK09L',
  , channelName  :: String -- 'directmessage',
  , userID       :: String -- 'U03BHK094',
  , userName     :: String -- 'jdwolk',
  , command      :: SlashCommand -- '/heyleo',
  , msgText      :: String -- 'awesomeness'
} deriving (Show)

instance FromJSON SlashMessage where
  parseJSON = withObject "slashMessage" $ \o ->
    SlashMessage
      <$> o .: "token"
      <*> o .: "team_id"
      <*> o .: "team_domain"
      <*> o .: "channel_id"
      <*> o .: "channel_name"
      <*> o .: "user_id"
      <*> o .: "user_name"
      <*> o .: "command"
      <*> o .: "text"

