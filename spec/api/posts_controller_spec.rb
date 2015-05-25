require 'spec_helper'

RSpec.describe API::PostsController, type: :controller do
  it 'creates a post with the correct params' do
    new_post = double('post', id: 1, save: true)
    allow(Post).to receive(:new).and_return(new_post)
    author = create(:user)

    post :create, post: { title: 'A post', body: "# Post\n With markdown", author: author.email }

    expect(Post).to have_received(:new).with(
      title: 'A post',
      body: "# Post\n With markdown",
      author_id: author.id
    )
    expect(new_post).to have_received(:save)
  end
end
