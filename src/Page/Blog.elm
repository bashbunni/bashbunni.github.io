module Page.Blog exposing (..)

import Html exposing (..)
import Html.Attributes exposing (alt, class, href)
import Http
import Json.Decode exposing (Decoder, field, int, list, map3, map5, string)


type State
    = Loading
    | ErrView string
    | Loaded


type alias Model =
    { blog : Blog
    , state : State
    }


displayPosts : Model -> Html Msg
displayPosts model =
    ul []
        (model.blog.items
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


type Msg
    = GotBlog (Result Http.Error Blog)


empty : Model
empty =
    { blog =
        { title = ""
        , author = ""
        , items = []
        }
    , state = Loading
    }


init : ( Model, Cmd Msg )
init =
    -- command fetches + decodes blog posts
    ( empty
    , Http.get
        { url = "/posts.json"
        , expect = Http.expectJson GotBlog blogDecoder
        }
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotBlog (Ok result) ->
            -- do something if everything loaded
            ( { model | blog = result }, Cmd.none )

        GotBlog (Err result) ->
            ( { model | state = ErrView result }, Cmd.none )


view : Model -> Html Msg
view _ =
    div [] [ text "welcome to my blog" ]


type alias Blog =
    { title : String
    , author : String
    , items : List Post
    }



-- blogDecoder: decode json into Blog type


blogDecoder : Decoder Blog
blogDecoder =
    map3 Blog
        (field "title" string)
        (field "title" string)
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
--
