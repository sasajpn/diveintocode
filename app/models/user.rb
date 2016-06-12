class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable
  
  mount_uploader :image, ImageUploader       

  has_many :blogs, dependent: :destroy
  

  
  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    unless user
    user = User.new(name:     auth.extra.raw_info.name, 
                       provider: auth.provider, 
                       uid:      auth.uid, 
                       email:    auth.info.email,
                      # password: Devise.friendly_token[0,20]
                      )
    end
    user
  end
  
  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    unless user
    user = User.new(name:     auth.info.nickname,
                       provider: auth.provider,
                       uid:      auth.uid,
                       email:    User.create_unique_email,
                      # password: Devise.friendly_token[0,20]
                      )
    end
    user
  end
  
  def self.create_unique_string
    SecureRandom.uuid
  end
  
  def self.create_unique_email
    User.create_unique_string + "@example.com"
  end
  
  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

end
