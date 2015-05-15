module Heyleo.Data.Message (
  Message(..)
) where

class Message a where
  sender :: a -> String
  text   :: a -> String
