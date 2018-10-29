//*********************************************
//  Task 1 - Repeat Numbers
//*********************************************
console.log();
console.log("Task 1 - Repeat Numbers");

var repeatNumbers = function(data) {
  var result="";
  for(i=0;i<data.length;i++){
    var num = data[i];
    var k = 0;
    while(k<num[1]){
            result= result + num[0];
            k++;
    }
    if(i<data.length-1){
      result= result + ",";
    }
  }
  return result;
};

console.log(repeatNumbers([[1, 10]]));
console.log(repeatNumbers([[1, 2], [2, 3]]));
console.log(repeatNumbers([[10, 4], [34, 6], [92, 2]]));

//*********************************************
// Task 2: Conditional Sums
//*********************************************
console.log();
console.log("Task 2: Conditional Sums");
var conditionalSum = function(values, condition) {
  var result=0;
  for(i=0;i<values.length;i++){
    if(condition==="even" && values[i]%2===0){
      result=result+values[i];
    }
    else if(condition==="odd" && values[i]%2!=0){
      result=result+values[i];
    }
  }
  return result;
};

console.log(conditionalSum([1, 2, 3, 4, 5], "even"));
console.log(conditionalSum([1, 2, 3, 4, 5], "odd"));
console.log(conditionalSum([13, 88, 12, 44, 99], "even"));
console.log(conditionalSum([], "odd"));

//*********************************************
// Task 3: Talking Calendar
//*********************************************
console.log();
console.log("Task 3: Talking Calendar");
var talkingCalendar = function(date) {
  var result="";//txt.split("/");
  var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

  var year=date.substr(0,4);
  var month=date.substr(5,2);
  var day=parseInt(date.substr(8,2));
  var result = result + months[parseInt(month)-1] + " ";
  var j = day % 10,
      k = day % 100;
    if (j == 1 && k != 11) {
        result = result +  day + "st";
    }
    else if (j == 2 && k != 12) {
        result = result +  day + "nd";
    }
    else if (j == 3 && k != 13) {
        result = result +  day + "rd";
    }
    else {
      result = result +  day + "th";
    }
    result = result +" , " +  year;
  return result;
};

console.log(talkingCalendar("2017/12/02"));
console.log(talkingCalendar("2007/11/11"));
console.log(talkingCalendar("1987/08/24"));

//*********************************************
// Task 4: Challenge Calculator
//*********************************************
console.log();
console.log("Task 4: Challenge Calculator");


var calculateChange = function(total, cash) {
  var obj={};
  var change = cash-total;
  //obj["change"]=change;
  while(change>0){
      if(change>=2000){
        obj["twentyDollars"]= Math.floor(change/2000);
        change=change-Math.floor(change/2000)*2000;
      }
      else if(change>=1000){
            obj["tenDollars"]=Math.floor(change/1000);
            change=change-Math.floor(change/1000)*1000;
          }
      else if(change>=500){
            obj["fiveDollars"]=Math.floor(change/500);
            change=change-Math.floor(change/500)*500;
          }
          else if(change>=200){
            obj["twoDollars"]=Math.floor(change/200);
            change -= Math.floor(change/200)*200;
          }
          else if(change>=100){
            obj["oneDollar"]=Math.floor(change/100);
            change=change-Math.floor(change/100)*100;
          }
          else if(change>=25){
            obj["quarter"]=Math.floor(change/25);
            change=change-Math.floor(change/25)*25;
          }
          else if(change>=10){
            obj["dime"]=Math.floor(change/10);
            change=change-Math.floor(change/10)*10;
          }
          else if(change>=5){
            obj["nickel"]=Math.floor(change/5);
            change=change-Math.floor(change/5)*5;
          }
          else if(change>=1){
            obj["penny"]=change;
            change=0;
          }
    }
  return obj;
};

console.log(calculateChange(1787, 2000));
console.log(calculateChange(2623, 4000));
console.log(calculateChange(501, 1000));

//var den=["twentyDollars","tenDollars","fiveDollars"
//,"twoDollars","oneDollar","quarter","dime","nickel","penny"];
