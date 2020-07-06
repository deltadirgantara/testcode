// setInterval(get_notification, 10000);

$(document).keypress(
  function(event){
    if (event.which == '13') {
      event.preventDefault();
    }
});

function update_notification(){
  $.ajax({ 
    type: 'GET', 
    url: '/api/update_notification', 
    success: function (result) {
      refresh_notification_list(result);
    }
  });
}

function get_notification(){
  $.ajax({ 
    type: 'GET', 
    url: '/api/get_notification', 
    success: function (result) { 
      refresh_notification_list(result);
    }
  });
}

function formatangka_titik(total) {
  var a = (total+"").replace(/[^\d]/g, "");

  var a = +a; // converts 'a' from a string to an int

  return formatNum(a);
}

function formatNum(rawNum) {
  rawNum = "" + rawNum; // converts the given number back to a string
  var retNum = "";
  var j = 0;
  for (var i = rawNum.length; i > 0; i--) {
    j++;
    if (((j % 3) == 1) && (j != 1))
      retNum = rawNum.substr(i - 1, 1) + "." + retNum;
    else
      retNum = rawNum.substr(i - 1, 1) + retNum;
  }
  return retNum;
}

function refresh_notification_list(result){
  data_length = result.length;
    types = ["primary", "warning", "danger", "success", "info"];
    icons = ["star", "exclamation-triangle", "times", "success", "info"];
    number_new_notif = result[0][1];
    if (number_new_notif > 0){
      document.getElementById("notif_number_badge").innerHTML = number_new_notif;
      document.getElementById("notif_number_badge").style.display = "inline";
    }else{
      document.getElementById("notif_number_badge").style.display = "none";
    }
    if (data_length > 1) {
      document.getElementById("notification_list").innerHTML = "";
      for(i = 1; i < data_length; i++){
        data = result[i];
        from = data[0];
        date = data[1];
        message = data[2];
        m_type = data[3];
        url = data[4];
        read = data[5];
        icon = icons[types.indexOf(m_type)];

        time = ""
        curr_date = new Date();
        notif_date = new Date(date);
        diff_date = (curr_date-notif_date)
        diffMs = (curr_date-notif_date);
        diffDays = Math.floor(diffMs / 86400000); // days
        diffHrs = Math.floor((diffMs % 86400000) / 3600000); // hours
        diffMins = Math.round(((diffMs % 86400000) % 3600000) / 60000); // minutes
        diffSecs = Math.round(((diffMs % 86400000) % 3600000) / 60000 / 60000); // seconds

        if(diffDays > 0){
          if (diffDays > 1){
            time+= diffDays+" day"
          }else{
            time+= diffDays+" days"
          }
        }else if(diffHrs > 0){
          if (diffHrs > 1){
            time+= diffHrs+" hour"
          }else{
            time+= diffHrs+" hours"
          }
        }else if(diffMins > 0){
          if (diffMins > 1){
            time+= diffMins+" minute"
          }else{
            time+= diffMins+" minutes"
          }
        }else{
          time+= "just now"
        }

        // alert(diffDays + " days, " + diffHrs + " hours, " + diffMins + " minutes, " + diffSecs + " seconds");

        element = "<a class='bq-"+m_type+" dropdown-item waves-effect waves-light' href='"+url+"'>"
        element+=   "<i class='fas fa-"+icon+" mr-2' aria-hidden='true'></i>"
        element+=     "<span>"+from+"</span>"
        element+=     "<br><span>"+message+"</span><br>"
        element+=     "<p class='span float-right'>"
        element+=       "<small>"+time+"</small>"
        element+=     "</p></a>"
        $("#notification_list").append(element);
      }
      element = "<a class='dropdown-item' href='/notifications'>"
      element+=  "<p class='span text-center'>"
      element+=    "Semua Notifikasi"
      element+=  "</p></a>"
      $("#notification_list").append(element);
    }
}

// SideNav Initialization
$(".button-collapse").sideNav();

var container = document.querySelector('.custom-scrollbar');
var ps = new PerfectScrollbar(container, {
  wheelSpeed: 2,
  wheelPropagation: true,
  minScrollbarLength: 20
});

// Data Picker Initialization
$('.datepicker').pickadate();


// Tooltips Initialization
$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})

// Small chart
$(function () {
  $('.min-chart#chart-sales').easyPieChart({
    barColor: "#FF5252",
    onStep: function (from, to, percent) {
      $(this.el).find('.percent').text(Math.round(percent));
    }
  });
});


var timeout = null;

function removeRowBuy(params){
  var row_idx = params.parentNode.parentNode.rowIndex;
  var table = document.getElementById("buys_table");
  if(table.rows.length > 1){
    table.deleteRow(row_idx);
  }
  // total_complain();
}

function removeRowSell(params){
  var row_idx = params.parentNode.parentNode.rowIndex;
  var table = document.getElementById("sells_table");
  if(table.rows.length > 1){
    table.deleteRow(row_idx);
  }
  // total_complain();
}

function getData(table_types) {
   clearTimeout(timeout);
   timeout = setTimeout(function() {
     var item_id = document.getElementById("itemId").value;
     if(table_types=="trx"){
        $.ajax({
         method: "GET",
         cache: false,
         url: "/api/trx?search=" + item_id,
         success: function(result_arr) {
            if(result_arr == ""){
              document.getElementById("itemId").value = "";
              alert("Data Barang Tidak Ditemukan")
              return
            }else{
              addNewRowTrxSell(result_arr);
            }
         },
         error: function(error) {
             document.getElementById("itemId").value = "";
             document.getElementById("itemId").focus();
         }
       });
     }else{

    }
   }, 300);
};

function addNewRowTrxSell(result_arr){
   var table = document.getElementById("sells_table");
   var result = result_arr;
   
   var row = table.insertRow(-1);
   var cell1 = row.insertCell(0);
   var cell2 = row.insertCell(1);
   var cell3 = row.insertCell(2);
   var cell4 = row.insertCell(3);
   var cell5 = row.insertCell(4);
   var cell6 = row.insertCell(5);
   var cell7 = row.insertCell(6);


   let id = "<input style='display: none;' type='text' class='md-form form-control' value='"+result[0]+"' readonly name='trxs[sell_item]["+add_counter+"][item_id]'/>";
   let code = id+"<input type='text' class='md-form form-control' value='"+result[1]+"' readonly name='trxs[sell_item]["+add_counter+"][code]'/>";
   let cat = "<input type='text' class='md-form form-control' value='"+result[2]+" - "+result[3]+"' readonly name='trxs[sell_item]["+add_counter+"][item_cat]'/>";
   let gold = "<input type='text' class='md-form form-control' value='"+result[4]+"' readonly name='trxs[sell_item]["+add_counter+"][gold]'/>";
   let weight = "<input type='number' class='md-form form-control' value='"+result[5]+"' readonly name='trxs[sell_item]["+add_counter+"][weight]'/>";
   let buy = "<input type='number' class='md-form form-control' value='"+result[6]+"' readonly name='trxs[sell_item]["+add_counter+"][buy]'/>";
   let total = "<input required type='number' class='md-form form-control' value='"+result[7]+"' min="+result[6]+" name='trxs[sell_item]["+add_counter+"][sell]'/>";
   let remove = "<i class='fa fa-trash text-danger' onclick='removeRowSell(this)'></i>"; 
   cell1.innerHTML = code;
   cell2.innerHTML = cat;
   cell3.innerHTML = gold;
   cell4.innerHTML = weight;
   cell5.innerHTML = buy;
   cell6.innerHTML = total;
   cell7.innerHTML = remove;
   add_counter++;
   cell1.style.verticalAlign = "middle";
   cell2.style.verticalAlign = "middle";
   cell3.style.verticalAlign = "middle";
   cell4.style.verticalAlign = "middle";
   cell5.style.verticalAlign = "middle";
   cell6.style.verticalAlign = "middle";
   cell7.style.verticalAlign = "middle";
   document.getElementById("itemId").value = "";
}
function addNewRowTrxBuy(){
   var gold_types = gon.gold_types;
   var gold_prices = gon.gold_prices;
   var table = document.getElementById("buys_table");
   
   var row = table.insertRow(-1);
   var cell1 = row.insertCell(0);
   var cell2 = row.insertCell(1);
   var cell3 = row.insertCell(2);
   var cell4 = row.insertCell(3);
   var cell5 = row.insertCell(4);


   let desc = "<input type='text' required class='md-form form-control' value='' name='trxs[buy_item]["+add_counter+"][description]'/>";
   let gold = '<select required name="trxs[buy_item]['+add_counter+'][gold]" required=true class="browser-default mdb-select md-form colorful-select dropdown-primary" display="block !important">';
   for (var i = 0; i < gold_types.length; i++) {
     gold+= '<option value="'+gold_types[i][0]+'"> '+ gold_types[i][1] +'</option>';
   }
   gold+="</select>";
   let weight = "<input required type='number' step='0.01' class='md-form form-control' value='0' min=0 name='trxs[buy_item]["+add_counter+"][weight]'/>";
   let total = "<input required type='number' class='md-form form-control' value='0' min=0 name='trxs[buy_item]["+add_counter+"][total]'/>";
   let remove = "<i class='fa fa-trash text-danger' onclick='removeRowBuy(this)'></i>"; 
   cell1.innerHTML = desc;
   cell2.innerHTML = gold;
   cell3.innerHTML = weight;
   cell4.innerHTML = total;
   cell5.innerHTML = remove;
   cell1.style.verticalAlign = "middle";
   cell2.style.verticalAlign = "middle";
   cell3.style.verticalAlign = "middle";
   cell4.style.verticalAlign = "middle";
   cell5.style.verticalAlign = "middle";
   add_counter++;
   return false;
}

$(function () {
  $('#dark-mode').on('click', function (e) {

    e.preventDefault();
    $('h4, button').not('.check').toggleClass('dark-grey-text text-white');
    $('.list-panel a').toggleClass('dark-grey-text');

    $('footer, .card').toggleClass('dark-card-admin');
    $('body, .navbar').toggleClass('white-skin navy-blue-skin');
    $(this).toggleClass('white text-dark btn-outline-black');
    $('body').toggleClass('dark-bg-admin');
    $('h6, .card, p, td, th, i, li a, h4, input, label').not(
      '#slide-out i, #slide-out a, .dropdown-item i, .dropdown-item').toggleClass('text-white');
    $('.btn-dash').toggleClass('grey blue').toggleClass('lighten-3 darken-3');
    $('.gradient-card-header').toggleClass('white black lighten-4');
    $('.list-panel a').toggleClass('navy-blue-bg-a text-white').toggleClass('list-group-border');

  });
});


// var add_counter = gon.inv_count;
var add_counter = 0

