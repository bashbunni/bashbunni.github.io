module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Page.About as About
import Page.Blog as Blog
import Page.Links as Links
import Url
import Url.Parser as Parser exposing (Parser)



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type alias Model =
    { key : Nav.Key
    , page : Page
    }



-- ROUTING
-- what do we show?


type Page
    = Home About.Model
    | Links Links.Model
    | Blog Blog.Model
    | NotFound



-- where are we?


type Route
    = HomeRoute
    | LinksRoute
    | BlogRoute
    | NotFoundRoute


urlToRoute : Url.Url -> Route
urlToRoute url =
    Parser.parse routeParser url
        |> Maybe.withDefault NotFoundRoute


routeParser : Parser (Route -> a) a
routeParser =
    Parser.oneOf
        [ Parser.map HomeRoute Parser.top
        , Parser.map LinksRoute (Parser.s "links")
        , Parser.map BlogRoute (Parser.s "blog")
        ]



-- INIT


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    changeRouteTo (urlToRoute url) { key = key, page = NotFound }


changeRouteTo : Route -> Model -> ( Model, Cmd Msg )
changeRouteTo route model =
    case route of
        HomeRoute ->
            About.init
                |> updateWith Home GotAboutMsg model

        LinksRoute ->
            Links.init
                |> updateWith Links GotLinksMsg model

        BlogRoute ->
            Blog.init
                |> updateWith Blog GotBlogMsg model

        NotFoundRoute ->
            ( { model | page = NotFound }, Cmd.none )


updateWith :
    (subModel -> Page)
    -> (subMsg -> Msg)
    -> Model
    -> ( subModel, Cmd subMsg )
    -> ( Model, Cmd Msg )
updateWith toPage toMsg model ( subModel, subCmd ) =
    ( { model | page = toPage subModel }
    , Cmd.map toMsg subCmd
    )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotAboutMsg About.Msg
    | GotLinksMsg Links.Msg
    | GotBlogMsg Blog.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    -- pushUrl changes URL, doesn't load new HTML (we need to
                    -- handle this ourselves). It also adds to the "browser
                    -- history" so users can use back and forward button.
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        ( UrlChanged url, _ ) ->
            changeRouteTo (urlToRoute url) model

        ( GotAboutMsg subMsg, Home about ) ->
            About.update subMsg about
                |> updateWith Home GotAboutMsg model

        ( GotLinksMsg subMsg, Links links ) ->
            Links.update subMsg links
                |> updateWith Links GotLinksMsg model

        ( GotBlogMsg subMsg, Blog blog ) ->
            Blog.update subMsg blog
                |> updateWith Blog GotBlogMsg model

        ( _, _ ) ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        viewPage toMsg title pageView =
            { title = title
            , body = [ Html.map toMsg pageView ]
            }
    in
    case model.page of
        Home about ->
            viewPage GotAboutMsg "bashbunni" (About.view about)

        Links links ->
            viewPage GotLinksMsg "Links" (Links.view links)

        Blog blog ->
            viewPage GotBlogMsg "Blog" (Blog.view blog)

        NotFound ->
            { title = "Not found"
            , body = [ text "404" ]
            }
