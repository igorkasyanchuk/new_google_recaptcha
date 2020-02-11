require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  fixtures :posts

  setup do
    @post = posts(:one)
  end

  test "should create post with recaptcha success" do
    stub_post_recaptcha_success

    assert_difference('Post.count', 1) do
      post posts_url, params: { post: { body: @post.body, title: @post.title } }
    end

    assert_redirected_to post_url(Post.last)
  end

  test "should not create post when failed to pass score level" do
    stub_post_recaptcha_fail_score

    assert_no_difference('Post.count') do
      post posts_url, params: { post: { body: @post.body, title: @post.title } }
    end

    assert_includes response.body.to_s, "Looks like you are not a human"
  end

  test "should not create post when failed to pass action match" do
    stub_post_recaptcha_fail_action

    assert_no_difference('Post.count') do
      post posts_url, params: { post: { body: @post.body, title: @post.title } }
    end

    assert_includes response.body.to_s, "Looks like you are not a human"
  end

  test "should update post with recaptcha success using defaults as arguments" do
    stub_post_recaptcha_success

    patch post_url(@post), params: { post: { body: @post.body, title: @post.title } }
    assert_redirected_to post_url(@post)
  end

  test "should not update post with recaptcha when failed to pass score level using defaults as arguments" do
    stub_post_recaptcha_fail_score

    patch post_url(@post), params: { post: { body: @post.body, title: @post.title } }
    assert_includes response.body.to_s, "Looks like you are not a human"
  end

  test "should not update post when failed to pass action match using defaults as arguments" do
    stub_post_recaptcha_fail_action

    patch post_url(@post), params: { post: { body: @post.body, title: @post.title } }
    assert_includes response.body.to_s, "Looks like you are not a human"
  end
end
