class GroupsController < ApplicationController
  before_filter :authenticate_user!, :except=>:receive_message
  before_filter :load_groups

  def index
    @groups = current_user.groups
    @page_title = "Your Groups"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  def show
    @group = Group.find(params[:id])
    @page_title = @group.title

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  def new
    @group = Group.new
    @page_title = "New Group"
    @students=[Student.new]*10
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  def edit
    @group = Group.find(params[:id])
    @page_title = "#{@group.title}"
    @students = @group.students
  end

  def create
    @group = Group.new(params[:group])
    @group.phone_number = get_new_phone_number
    @page_title = "New Groups"
		
    respond_to do |format|
      if @group.save
        format.html { redirect_to(edit_memberships_of_group_path(@group), :notice => 'Group was successfully created.') }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        #TODO: find a better, less API-intensive way to ensure we don't abuse our tropo provisioning
        if @group.phone_number.nil?
          @group.errors[:phone_number] = ["could not provision phone number at this time"]
        else
          destroy_phone_number(@group.phone_number)
          @group.phone_number=nil
        end
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end

  end

  def update
    @group = Group.find(params[:id])
    @page_title = "#{@group.title}"
    
    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to(groups_url, :notice => 'Group was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end
  
  #put. add single student, by :student_id
  def add_student
    @group = Group.find(params[:id])
    @student=Student.find(params[:student_id])
    @group.students << @student unless @group.students.include? @student
    respond_to do |format|
      format.xml {head "ok"}#TODO: better return
    end
  end 
  
  #delete. remove single student, by :student_id
  def remove_student
    @group = Group.find(params[:id])
    @student=Student.find(params[:student_id])
    @group.students.delete(@student)
    respond_to do |format|
      format.xml {head "ok"}
    end
  end
  
  
  #for now, acts more like 'add members'
  def update_memberships
    @group = Group.find(params[:id])

    @students = params[:students].reject {|s| s.values.all?(&:blank?)}.map do |student_params|
      student_params[:phone_number] = PhoneValidator::massage_number(student_params[:phone_number])
      Student.find_or_initialize_by_phone_number(student_params)
    end
    
    respond_to do |format|
           #does the map, so that we don't short circuit
      if (@students.map(&:valid?).all? && @students.all?(&:save) && @group.students += @students)
        #it succeeded
        format.html { redirect_to :group, :notice=>"#{@students.count} students added successfully"}
        format.xml  {head "ok"}
      else
        format.html {render :action=>:edit_memberships}
        format.xml  { render :xml => @students.map(&:errors), :status => :unprocessable_entity }
      end
    end
  end
  def edit_memberships
    @group = Group.find(params[:id])
    @students=[Student.new]*10
  end
  
  #POST groups/:id/send_message, sends a message to all members of group
  def send_message
    @group = Group.find(params[:id])
    message = @group.user.display_name+": "+params[:message][:content] #TODO: safety, parsing, whatever.
    #TODO: ensure group found
    numbers = @group.students.map(&:phone_number)
    numbers << @group.user.phone_number if @group.user.phone_number

    if params[:commit].match /scheduled/i
      time_zone = ActiveSupport::TimeZone["Eastern Time (US & Canada)"]  #use eastern time for the input
      
      scheduled_run = time_zone.local(*params[:date].values_at(*%w{year month day hour}).map(&:to_i))
      
      #schedule 5 minutes early so we don't accidentally hit anything silly on cron job execution time
      $outbound_flocky.delay(:run_at=>scheduled_run-5.minutes).message @group.phone_number, message, numbers
      pretty_time = scheduled_run.strftime("%A, %B %d, %I:%M %p %Z")
      redirect_to @group, :notice=>"Message successfully scheduled for #{pretty_time}" #if actually successful, or something
    else
      response = $outbound_flocky.message @group.phone_number, message, numbers
      redirect_to @group, :notice=>"Message sent successfully" #if actually successful, or something
    end

  end
  
  #POST groups/receive_message, receives a message as a JSON post, and figures out what to do with it.
  def receive_message
    params[:incoming_number] = $1 if params[:incoming_number]=~/^1(\d{10})$/
    params[:origin_number] = $1 if params[:origin_number]=~/^1(\d{10})$/
    @group=Group.find_by_phone_number(params[:incoming_number])
    
    if @group
      sent_by_admin=@group.user.phone_number==params[:origin_number]
      @sending_student = @group.students.find_by_phone_number(params[:origin_number])
      if sent_by_admin || @sending_student
        message = (sent_by_admin ? @group.user.display_name : @sending_student.name)+": "+params[:message]
        numbers = (@group.students-[@sending_student]).map do |student|
          student.phone_number
        end
      
        numbers << @group.user.phone_number if @group.user.phone_number
        response = $outbound_flocky.message @group.phone_number, message, numbers
      end
    end
    
    render :text=> response.to_json, :status=>202
    #needs to return something API-like, yo
  end
  
  def load_groups
    @groups = Group.all
  end

  private
  def get_new_phone_number
    r=$outbound_flocky.create_phone_number_synchronous("1617")
    if r[:response].code == 200
      return r[:response].parsed_response["href"].match(/\+1(\d{10})/)[1] rescue nil
    end
    
    return nil
  end
  def destroy_phone_number(num)
    $outbound_flocky.destroy_phone_number_synchronous(num)
  end
end
