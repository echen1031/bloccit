class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates :body, length: { minimum: 5}, presence: true

  after_create :send_favorite_emails

  private

  def send_favorite_emails
    # for every favorite associated with post, send email
    self.post.favorites.each do |favorite|

      if favorite.user_id != self.user_id && favorite.user.email_favorites?
        #if the user who has favorited the post is not equal to the user who made the comment, plus the user has checked email favorites in his profile.
        FavoriteMailer.new_comment(favorite.user, self.post, self).deliver
      end
    end
  end
end
