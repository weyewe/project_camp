class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name 
  # attr_accessible :title, :body
  
  has_many :assignments
  has_many :roles, :through => :assignments
  
  validates_presence_of :name, :email 
  
  
  
=begin
  CREATE_BASIC_USER
=end

  def User.create_basic_user(employee,  user_params ) 
    if not employee.has_role?(:admin)
      return nil
    end
    
    password = 'willy1234'
    user_params[:password] = password
    user_params[:password_confirmation] = password
    user = User.create user_params
    if user.errors.messages.length != 0 
      puts "111 There is errorr.. returning \n"*10
      return user
    end
    
    puts "GONNA UPGRADE TO BASIC USER \n"*10
    user.upgrade_to_basic_user
    user.reload 
    return user 
  end
  
  def upgrade_to_basic_user 
    
    employee_role = Role.find_by_name(USER_ROLE[:employee])  
    self.add_role_if_not_exists(employee_role )  
  end
  
  
=begin
  CREATE MAIN USER 
=end

  def User.create_main_user( user_params ) 
    user = User.create user_params
    if user.errors.messages.length != 0 
      return user 
    end
    
    user.upgrade_to_main_user  
    return user 
  end
  
  # only called in the seeds or from command line .. 1 app == 1 main user 
  def upgrade_to_main_user
    self.is_main_user = true 
    self.save 
    
    admin_role = Role.find_by_name(USER_ROLE[:admin])  
    self.add_role_if_not_exists(admin_role )  
  end
  
  def add_main_user_role( role_list ) 
    if self.is_main_user == true 
      role_list.each do |role|
        self.add_role_if_not_exists( role ) 
      end
    end
  end
  
  
=begin
  CREATE USER WITH ROLE 
=end
  def User.create_user_with_role( employee, role_list , user_params)
    if not employee.has_role?(:admin)
      puts "THE EMPLOYEE DOESN't HAVE ROLE ADMIN"
      return nil
    end
    
    user = User.create user_params 
    if user.errors.messages.length != 0 
      return user
    end
    
    role_list.each do |role|
      user.add_role_if_not_exists( role   ) 
    end 
    
    return user 
  end
  
=begin
  ROLE VERIFICATION 
=end
  
  
  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end
  
  def add_role_if_not_exists( role )
    if roles.map{|x| x.id}.include?(role.id)
      return nil
    else
      # create the role assignment 
      Assignment.create(:user_id => self.id, 
      :role_id => role.id )
    end
  end 
   
  def add_role( role,  employee)
    if not employee.has_role?(:admin)
      return false
    end

    self.add_role_if_not_exists( role )  
  end
  
  def remove_role(role,  employee)
    if  not employee.has_role?(:admin)
      puts "not valid role updating info"
      return nil
    end
     
    
    if roles.map{|x| x.id}.include?(role.id)
      if self.is_main_user==true  && role.id == Role.find_by_name(USER_ROLE[:admin]).id
        puts "has the role id , but it is the main user"
        return nil
      end
      # destroy the role assignment 
      assignments = Assignment.find(:all, :conditions => {
        :role_id => role.id,
        :user_id => self.id 
      })
      
      assignments.each do |assignment|
        assignment.destroy
      end
      
    else
      puts "there is no mentioned role id"
      return nil
    end 
  end
  
  
end
