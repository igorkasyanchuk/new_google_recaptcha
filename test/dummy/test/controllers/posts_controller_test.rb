require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  def stub_recaptcha_success
    stub_request(
      :get,
      "https://www.google.com/recaptcha/api/siteverify?secret=#{NewGoogleRecaptcha.secret_key}&response="
    ).to_return(
      status: 200,
      body: {
        "success": true,
        "challenge_ts": "2018-12-31T15:36:25Z",
        "hostname": "localhost",
        "score": 0.9,
        "action": "manage_posts"
      }.to_json,
      headers: {}
    )
  end
  fixtures :posts

  setup do
    @post = posts(:one)
    stub_recaptcha_success
  end

  test "should get index" do
    get posts_url
    assert_response :success
  end

  test "should get new" do
    get new_post_url
    assert_response :success
  end

  test "should create post" do
    assert_difference('Post.count', 1) do
      post posts_url, params: { post: { body: @post.body, title: @post.title } }
    end

    assert_redirected_to post_url(Post.last)
  end

  test "should show post" do
    get post_url(@post)
    assert_response :success
  end

  test "should get edit" do
    get edit_post_url(@post)
    assert_response :success
  end

  test "should update post" do
    patch post_url(@post), params: { post: { body: @post.body, title: @post.title } }
    assert_redirected_to post_url(@post)
  end

  test "should destroy post" do
    assert_difference('Post.count', -1) do
      delete post_url(@post)
    end

    assert_redirected_to posts_url
  end
end
