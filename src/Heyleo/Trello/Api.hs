{-# LANGUAGE OverloadedStrings #-}

module Heyleo.Trello.Api (
  TrelloConfig(..),
  createCard
) where

import Heyleo.Data.Message (text, sender, Message)
import Network.Wreq (
  post, responseStatus, statusCode, FormParam((:=)), Response
  )
import Control.Lens ((^.))
import Data.List (intersperse)

data TrelloConfig = TrelloConfig {
  trelloKey     :: String
, trelloToken   :: String
, boardID       :: String
, listID        :: String
, memberIDs     :: String -- comma separated string of IDs
} deriving (Show)

apiBase :: String
apiBase = "https://api.trello.com/1"

cardsURL :: String
cardsURL = apiBase ++ "/cards"

--- URL generation stuff should be moved out

makeQueryParam :: (String, String) -> String
makeQueryParam (name, val) = name ++ "=" ++ val

makeQueryParams :: [(String, String)] -> [String]
makeQueryParams pms = map makeQueryParam pms

makeQueryString :: [(String, String)] -> String
makeQueryString queryParams = concat . intersperse "&" $ makeQueryParams queryParams

makeURL :: String -> [(String, String)] -> String
makeURL urlBase queryParams = urlBase ++ "?" ++ (makeQueryString queryParams)

---

getStatus :: Response b -> Int
getStatus res = res ^. responseStatus . statusCode

handleCreateStatus :: Message m => m -> Int -> Either String String
handleCreateStatus msg status = case status of
  200 -> Right $ text msg
  _   -> Left "Card could not be created"

cardDescription :: Message m => m -> String
cardDescription msg = "(From " ++ (sender msg) ++ ")"

createCard :: Message m => TrelloConfig -> m -> IO (Either String String)
createCard cfg msg = do
  let queryParams = [("key", trelloKey cfg), ("token", trelloToken cfg)]
      url = makeURL cardsURL queryParams
  res <- post url [
    "name"        := text msg,
    "desc"        := cardDescription msg,
    "idList"      := listID cfg,
    "due"         := (),
    "urlSource"   := (),
    "idMembers"   := memberIDs cfg
    ]
  status <- return $ getStatus res
  return $ handleCreateStatus msg status

