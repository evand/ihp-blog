module Web.View.Posts.Show where
import Web.View.Prelude
import qualified Text.MMark as MMark

data ShowView = ShowView { post :: Include "comments" Post }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>{get #title post}</h1>
        <p>{get #createdAt post |> dateTime}</p>
        <div>{get #body post |> renderMarkdown}</div>

        <a href={NewCommentAction (get #id post)}>Add Comment</a>

        <div>{forEach (get #comments post) renderComment}</div>
    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Posts" PostsAction
                            , breadcrumbText "Show Post"
                            ]

renderMarkdown text =
    case text |> MMark.parse "" of
        Left error -> "Markdown parse error"
        Right markdown -> MMark.render markdown |> tshow |> preEscapedToHtml

renderComment comment = [hsx|
        <div class="mt-4">
            <h5>{get #author comment}</h5>
            <p>{get #body comment}</p>
        </div>
    |]
