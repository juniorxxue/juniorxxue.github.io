--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll


--------------------------------------------------------------------------------
config :: Configuration
config = defaultConfiguration
  { destinationDirectory = "docs"
  }

main :: IO ()
main = hakyllWith config $ do
    match "fonts/**" $ do
        route   idRoute
        compile copyFileCompiler

    match "slides/**" $ do
        route   idRoute
        compile copyFileCompiler

    match "paper/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "proof/**" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["about.html"]) $ do
        route   idRoute
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "fpslides.md" $ do
      route $ setExtension "html"
      compile $ pandocCompiler
        >>= loadAndApplyTemplate "templates/default.html" defaultContext
        >>= relativizeUrls

    match "haskell/toc.md" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
          >>= loadAndApplyTemplate "templates/default.html" defaultContext
          >>= relativizeUrls

    match "haskell/chapters/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
          >>= loadAndApplyTemplate "templates/haskell.html" defaultContext
          >>= loadAndApplyTemplate "templates/default.html" defaultContext
          >>= relativizeUrls

    match "haskell/12weeks/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
          >>= loadAndApplyTemplate "templates/haskell.html" defaultContext
          >>= loadAndApplyTemplate "templates/default.html" defaultContext
          >>= relativizeUrls

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    match "index.html" $ do
        route idRoute
        compile $ do
            posts            <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts"            postCtx (return posts)            `mappend`
                    constField "title" "Home"                                      `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%Y-%m-%d" `mappend`
    defaultContext
