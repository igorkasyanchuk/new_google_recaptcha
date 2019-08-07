require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest
  fixtures :books

  setup do
    @book = books(:one)
  end

  test "should create book with recaptcha success and store score in Book" do
    stub_book_recaptcha_success

    assert_difference('Book.count', 1) do
      post books_url, params: { book: { author: @book.author, title: @book.title } }
    end

    assert_redirected_to book_url(Book.last)

    assert_equal(Book.last.humanity_score, 0.9)
  end

  test "should not create book when failed to pass score level" do
    stub_book_recaptcha_fail_score

    assert_no_difference('Book.count') do
      post books_url, params: { book: { author: @book.author, title: @book.title } }
    end

    assert_includes response.body.to_s, "Looks like you are not a human"
  end

  test "should not create book when failed to pass action match" do
    stub_book_recaptcha_fail_action

    assert_no_difference('Book.count') do
      post books_url, params: { book: { author: @book.author, title: @book.title } }
    end

    assert_includes response.body.to_s, "Looks like you are not a human"
  end

  test "should update book with recaptcha success using defaults as arguments" do
    stub_book_recaptcha_success

    patch book_url(@book), params: { book: { author: @book.author, title: @book.title } }

    assert_redirected_to book_url(@book)

    assert_equal(Book.last.humanity_score, 0.9)
  end

  test "should not update book with recaptcha when failed to pass score level using defaults as arguments" do
    stub_book_recaptcha_fail_score

    patch book_url(@book), params: { book: { author: @book.author, title: @book.title } }

    assert_includes response.body.to_s, "Looks like you are not a human"
  end

  test "should not update book when failed to pass action match using defaults as arguments" do
    stub_book_recaptcha_fail_action

    patch book_url(@book), params: { book: { author: @book.author, title: @book.title } }

    assert_includes response.body.to_s, "Looks like you are not a human"
  end
end
