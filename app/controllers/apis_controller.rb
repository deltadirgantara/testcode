class ApisController < ApplicationController
  before_action :require_login

  def index
    api_type = params[:api_type]
    if api_type == "trx"
      get_item params
    elsif api_type == "get_notification"
      get_notification params
    elsif api_type == "update_notification"
      update_notification params
    end   
  end

  def get_user_salary params
    json_result = []
    user_id = params[:id].squish
    return render :json => json_result unless user_id.present?
    user = User.find_by(id: user_id)
    if user.present? 
      user_debt = Receivable.where("deficiency > 0").where(finance_type: Receivable::EMPLOYEE).where(to_user: user_id).sum(:deficiency)
      json_result << view_context.number_with_delimiter(user.salary, delimiter: ".", separator: ",")
      json_result << view_context.number_with_delimiter(user_debt.to_i, delimiter: ".", separator: ",")
      # json_result << view_context.number_to_currency(user.salary) 
      # json_result << view_context.number_to_currency(user_debt)
    end
    render :json => json_result
  end

   def get_notification params
    json_result = []
    unread_notifications = Notification.where(to_user: current_user, read: 0).order("date_created DESC")
    notifications = Notification.where(to_user: current_user, read: 0).order("date_created DESC").limit(5)

    json_result << [DateTime.now, unread_notifications.count]
    notifications.each do|notification|
      json_result << [notification.from_user.name, notification.date_created, notification.message, notification.m_type, notification.link, notification.read]
    end
    render :json => json_result
  end

  def update_notification params
    json_result = []
    Notification.where(to_user: current_user, read: 0).order("date_created DESC").update_all(read: 1)
    notifications = Notification.where(to_user: current_user).order("date_created DESC").limit(5)

    json_result << [DateTime.now, 0]
    notifications.each do|notification|
      json_result << [notification.from_user.name, notification.date_created, notification.message, notification.m_type, notification.link, notification.read]
    end
    render :json => json_result
  end

  def get_item params
    json_result = {}
    search = params[:search].squish
    return render :json => json_result unless search.present?
    search = search.gsub(/\s+/, "")
    item = Item.where(store: current_user.store).find_by('lower(code) like ?', search.downcase)
    return render :json => json_result unless item.present?
    json_result["id"] = item.id
    json_result["code"] = item.code
    json_result["category"] = item.sub_category.category.name
    json_result["sub_category"] = item.sub_category.name
    json_result["gold_type"] = item.gold_type.name
    json_result["weight"] = item.weight
    json_result["buy"] = item.buy
    json_result["sell"] = item.weight * item.gold_type.gold_price.sell
    json_result["image_url"] = item.image
    render :json => json_result.values
  end

end