require 'axlsx'
require 'csv'

class Admin::ReportsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin
  
    def index
    end
  
    def users_report
      @users = User.left_joins(:posts, :comments, :likes)
                   .select("users.first_name || ' ' || users.last_name AS name, COUNT(DISTINCT posts.id) AS post_count, COUNT(DISTINCT comments.id) AS comment_count, COUNT(DISTINCT likes.id) AS like_count")
                   .group("users.id")
      respond_to do |format|
        format.csv { send_data generate_csv(@users), filename: "users_report.csv" }
        format.xlsx { send_data generate_xlsx(@users), filename: "users_report.xlsx" }
      end
    end
  
    def active_users_report
      @users = User.left_joins(:posts, :comments, :likes)
                   .select("users.first_name || ' ' || users.last_name AS name, COUNT(DISTINCT posts.id) AS post_count, COUNT(DISTINCT comments.id) AS comment_count, COUNT(DISTINCT likes.id) AS like_count")
                   .group("users.id")
                   .having("COUNT(posts.id) > 10")
      respond_to do |format|
        format.csv { send_data generate_csv(@users), filename: "active_users_report.csv" }
        format.xlsx { send_data generate_xlsx(@users), filename: "active_users_report.xlsx" }
      end
    end
  
    def posts_report
        @posts = Post
          .joins(:user)
          .left_joins(:comments, :likes)
          .select("users.first_name || ' ' || users.last_name AS name, posts.title, posts.description, COUNT(DISTINCT comments.id) AS comment_count, COUNT(DISTINCT likes.id) AS like_count")
          .group("users.first_name, users.last_name, posts.id")
      
        respond_to do |format|
          format.csv { send_data generate_csv1(@posts), filename: "posts_report.csv" }
          format.xlsx { send_data generate_xlsx1(@posts), filename: "posts_report.xlsx" }
        end
      end      
  
    private
    
    def generate_csv1(records)
        CSV.generate(headers: true) do |csv|
          csv << ["User Name", "Title", "Description", "Comments", "Likes"]  # Updated headers
          records.each do |record|
            csv << [record.name, record.title, record.description, record.comment_count, record.like_count]
          end
        end
      end      
    def generate_csv(records)
        require 'csv'  # Ensure it's loaded
      
        CSV.generate(headers: true) do |csv|
          csv << ["Name", "Posts", "Comments", "Likes"]  # Add headers
          records.each do |record|
            csv << [record.name, record.posts.count, record.comments.count, record.likes.count]
          end
        end
      end
      
  
    def generate_xlsx(records)
        require 'axlsx'  # Ensure it's loaded
      
        package = Axlsx::Package.new
        workbook = package.workbook
        workbook.add_worksheet(name: "Report") do |sheet|
          sheet.add_row ["Name", "Posts", "Comments", "Likes"]  # Add headers
          records.each do |record|
            sheet.add_row [record.name, record.posts.count, record.comments.count, record.likes.count]
          end
        end
      
        package.to_stream.read
      end
      
      def generate_xlsx1(records)
        package = Axlsx::Package.new
        workbook = package.workbook
        workbook.add_worksheet(name: "Report") do |sheet|
          sheet.add_row ["User Name", "Title", "Description", "Comments", "Likes"]  # Updated headers
          records.each do |record|
            sheet.add_row [record.name, record.title, record.description, record.comment_count, record.like_count]
          end
        end
        package.to_stream.read
      end
      
    def authorize_admin
      redirect_to root_path, alert: "Unauthorized Access" unless current_user.has_role?(:admin)
    end
  end
  