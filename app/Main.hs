module Main (main) where

import Control.Concurrent
import Control.Monad

server :: MVar () -> MVar String -> IO ()
server endEvent mv = do
    putStrLn "server start"
    void $ forever $ do
        x <- takeMVar mv
        putStrLn x
    putStrLn "server end"
    putMVar endEvent ()

client :: String -> MVar String -> IO ()
client name mv = do
    putStrLn $ "client " ++ name ++ " started"
    putMVar mv $ "hello from " ++ name
    putStrLn $ "client " ++ name ++ " done"

main :: IO ()
main = do
    endEvent <- newEmptyMVar
    mv <- newEmptyMVar
    void $ forkIO $ server endEvent mv
    void $ forkIO $ client "1" mv
    void $ forkIO $ client "2" mv
    threadDelay 10000000
