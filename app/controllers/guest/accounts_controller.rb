class Guest::AccountsController < ActionController::Base
  # GET /guest/accounts
  # GET /guest/accounts.json
  def index
    @guest_accounts = AccountSession.joins(:account).where(:finished => false).where("accounts.status = 'bslock'")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @guest_accounts }
    end
  end

  # GET /guest/accounts/1
  # GET /guest/accounts/1.json
  def show
    @guest_account = Guest::Account.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @guest_account }
    end
  end

  # GET /guest/accounts/new
  # GET /guest/accounts/new.json
  def new
    @guest_account = Guest::Account.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @guest_account }
    end
  end

  # GET /guest/accounts/1/edit
  def edit
    @guest_account = Guest::Account.find(params[:id])
  end

  # POST /guest/accounts
  # POST /guest/accounts.json
  def create
    @guest_account = Guest::Account.new(params[:guest_account])

    respond_to do |format|
      if @guest_account.save
        format.html { redirect_to @guest_account, notice: 'Account was successfully created.' }
        format.json { render json: @guest_account, status: :created, location: @guest_account }
      else
        format.html { render action: "new" }
        format.json { render json: @guest_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /guest/accounts/1
  # PUT /guest/accounts/1.json
  def update
    @guest_account = Guest::Account.find(params[:id])

    respond_to do |format|
      if @guest_account.update_attributes(params[:guest_account])
        format.html { redirect_to @guest_account, notice: 'Account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @guest_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /guest/accounts/1
  # DELETE /guest/accounts/1.json
  def destroy
    @guest_account = Guest::Account.find(params[:id])
    @guest_account.destroy

    respond_to do |format|
      format.html { redirect_to guest_accounts_url }
      format.json { head :no_content }
    end
  end
end
