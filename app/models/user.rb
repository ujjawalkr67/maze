class User < ApplicationRecord
  rolify
  after_create :assign_default_role
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :comments, dependent: :destroy
  has_many :posts, dependent: :destroy

  validates :first_name, :last_name, :email, :phone_number, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :phone_number, uniqueness: true, numericality: { only_integer: true }, length: { is: 10 }

  # Ensure users are active by default
  after_initialize :set_default_active_status, if: :new_record?
  def activate!
    update(active: true)
  end

  def deactivate!
    update(active: false)
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end
  private
  def set_default_active_status
    self.active ||= true
  end
  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end
end
