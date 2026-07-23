module Page.Blog exposing (..)

import Html exposing (..)
import Html.Attributes exposing (alt, class, href)
import Http
import Json.Decode exposing (Decoder, field, int, list, map3, map5, string)


type State
    = Loading
    | ErrView Http.Error
    | Loaded Blog


type alias Model =
    State


displayPosts : Model -> Html Msg
displayPosts model =
    case model of
        Loaded blog ->
            ul []
                (blog.items
                    |> List.map
                        (\item ->
                            li []
                                [ a
                                    [ class "blog-link"
                                    , href item.url
                                    , alt item.title
                                    ]
                                    [ text item.title ]
                                ]
                        )
                )

        _ ->
            div [] [ text "nothing yet!" ]


type Msg
    = GotBlog (Result Http.Error Blog)


init : ( Model, Cmd Msg )
init =
    -- command fetches + decodes blog posts
    ( Loading
    , Http.get
        { url = "/posts.json"
        , expect = Http.expectJson GotBlog blogDecoder
        }
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        GotBlog (Ok result) ->
            -- do something if everything loaded
            ( Loaded result, Cmd.none )

        GotBlog (Err result) ->
            ( ErrView result, Cmd.none )


view : Model -> Html Msg
view model =
    case model of
        Loading ->
            div [] [ text "loading" ]

        Loaded _ ->
            -- TODO just pass blog, not the whole model
            displayPosts model

        ErrView err ->
            div [] [ text ("ran into an error :(" ++ errorToString err) ]


errorToString : Http.Error -> String
errorToString error =
    case error of
        Http.NetworkError ->
            "Network error"

        Http.Timeout ->
            "Timed out"

        Http.BadUrl url ->
            "Bad URL: " ++ url

        Http.BadBody body ->
            "Bad BODY: " ++ body

        Http.BadStatus status ->
            "Bad STATUS: " ++ String.fromInt status


type alias Blog =
    { title : String
    , author : String
    , items : List Post
    }


blogDecoder : Decoder Blog
blogDecoder =
    map3 Blog
        (field "title" string)
        (field "author" string)
        (field "items" (list postDecoder))


type alias Post =
    { id : Int
    , url : String
    , title : String
    , content : String
    , datePublished : String
    }


postDecoder : Decoder Post
postDecoder =
    map5 Post
        (field "id" int)
        (field "url" string)
        (field "title" string)
        (field "content_html" string)
        (field "date_published" string)



-- TODOs
-- TODO list of blog posts, routing to each page
-- need loading state?
-- TODO figure out how to init THIS model; does it start empty, then fetch posts from
-- init, to handle in update?
-- TODO centralize state to hold blog; you can't have blog when it's loading anyway
