require 'axlsx'
require 'csv'

class Admin::ReportsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin
  
    def index
    end
  
    def users_report
      @users = User.left_joins(:posts)
                   .select("users.id, users.first_name || ' ' || users.last_name AS name, COUNT(DISTINCT posts.id) AS post_count,
                            COALESCE(SUM((SELECT COUNT(*) FROM comments WHERE comments.post_id = posts.id)), 0) AS total_comments,
                            COALESCE(SUM((SELECT COUNT(*) FROM likes WHERE likes.likeable_id = posts.id AND likes.likeable_type = 'Post')), 0) AS total_likes")
                   .group("users.id")
    
      respond_to do |format|
        format.csv { send_data generate_csv(@users), filename: "users_report.csv" }
        format.xlsx { send_data generate_xlsx(@users), filename: "users_report.xlsx" }
      end
    end
    
  
    def active_users_report
      @users = User.left_joins(:posts)
                   .select("users.id, users.first_name || ' ' || users.last_name AS name, COUNT(DISTINCT posts.id) AS post_count,
                            COALESCE(SUM((SELECT COUNT(*) FROM comments WHERE comments.post_id = posts.id)), 0) AS total_comments,
                            COALESCE(SUM((SELECT COUNT(*) FROM likes WHERE likes.likeable_id = posts.id AND likes.likeable_type = 'Post')), 0) AS total_likes")
                   .group("users.id").having("COUNT(posts.id) > 3")
    
      respond_to do |format|
        format.csv { send_data generate_csv(@users), filename: "users_report.csv" }
        format.xlsx { send_data generate_xlsx(@users), filename: "users_report.xlsx" }
      end
    end
  
    def posts_report
      @posts = Post
        .joins(:user)
        .left_joins(:comments, :likes)
        .select("
          users.first_name || ' ' || users.last_name AS author_name, 
          posts.title, 
          posts.description, 
          COALESCE(STRING_AGG(DISTINCT comments.data, ' | '), 'No Comments') AS comment_data, 
          COUNT(DISTINCT likes.id) AS like_count
        ")
        .group("users.first_name, users.last_name, posts.id")
    
      respond_to do |format|
        format.csv { send_data generate_csv1(@posts), filename: "posts_report.csv" }
        format.xlsx { send_data generate_xlsx1(@posts), filename: "posts_report.xlsx" }
      end
    end
  
    private
    def generate_csv1(posts)
      CSV.generate(headers: true) do |csv|
        csv << ["Author", "Title", "Description", "Comments", "Likes"]  # Headers
    
        posts.each do |post|
          csv << [post.author_name, post.title, post.description, post.comment_data, post.like_count]
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
      
      def generate_xlsx1(posts)
        package = Axlsx::Package.new
        workbook = package.workbook
      
        workbook.add_worksheet(name: "Posts Report") do |sheet|
          sheet.add_row ["Author", "Title", "Description", "Comments", "Likes"] # Headers
      
          posts.each do |post|
            comments_text = post.comment_data || "No Comments"  # Directly use the string
            sheet.add_row [post.author_name, post.title, post.description, comments_text, post.like_count]
          end
        end
      
        package.to_stream.read
      end
      
      
    def authorize_admin
      redirect_to root_path, alert: "Unauthorized Access" unless current_user.has_role?(:admin)
    end
  end
  