
/*
Database: ecommerce
table: orders
*/

-- q1

select 
    status,
    sum(grand_total) as total_sales,
    sum(qty_ordered) as total_quantity,
    count(distinct increment_id) as total_orders
from orders
group by status
order by total_sales desc;

/*
status          total_sales        total_quantity  total_orders
--------------  -----------------  --------------  ------------
canceled        2758959398.20141   270127          146602
complete        1119002749.57911   274348          167273
received        434834784.42599    110160          35778
order_refunded  406193247.484998   73031           48203
refund          30086111.042       9447            3987
cod             12372872.48        3358            874
paid            8808178.704        1720            293
closed          3597710.54         536             330
pending         1253714.6          70              43
holded          1173530.5          36              20
fraud           626944             10              10
payment_review  234649.7           168             39
processing      161149.87          30              19
pending_paypal  10877              9               5
exchange        5764               4               4
*/

--q2
select 
    payment_method,
    count(distinct increment_id) as total_orders,
    avg(grand_total) as avg_grand_total,
    avg(discount_amount) as avg_discount_amount
from orders
group by payment_method
having count(distinct increment_id) > 100
order by avg_grand_total desc;

/*
payment_method                                     total_orders avg_grand_total        avg_discount_amount
-------------------------------------------------- ------------ ---------------------- ----------------------
bankalfalah                                        16880        28412.0122815967       349.92343928649
ublcreditcard                                      644          24297.7060217654       0
mygateway                                          344          21361.9293450479       2.48115015974441
easypay_voucher                                    27433        18023.6865404031       2198.78940834102
apg                                                1238         13994.579087279        563.023177410154
internetbanking                                    316          13417.8967873303       1.58371040723982
payaxis                                            67138        11686.8570966825       737.237338001126
jazzvoucher                                        12632        11400.6110188485       1307.12185309931
easypay                                            60101        10947.4840672995       658.16567012385
mcblite                                            497          10438.3552631579       13.1578947368421
easypay_ma                                         9985         7683.69438498467       663.843254531124
cashatdoorstep                                     375          7147.23758099352       0.19438444924406
cod                                                179401       3889.36071068827       71.181133644261
jazzwallet                                         21314        3626.43519004082       472.57398510724
customercredit                                     5083         16.5943647731808       61.3221936942929

*/

--q3
select top 5
    category_name_1,
    sum(qty_ordered) as total_qty
from orders
group by category_name_1
order by total_qty desc;


/*
category_name_1   total_qty
----------------  ---------
mobiles & tablets 126575
men's fashion     101583
others            86548
superstore        83352
women's fashion   64215
*/

--q4
select * from orders
where grand_total > (select avg(grand_total) from orders);

--q5
select 
category_name_1,
sum(discount_amount) as total_discount,
avg(discount_amount) as avg_discount,
count(*) as discount_order_count
from orders
where discount_amount > 0
group by category_name_1;

/*
category_name_1     total_discount    avg_discount      discount_order_count
------------------  ----------------  ----------------  --------------------
entertainment       49504247.029799   2720.31250850637  18198
others              1451906.52249999  495.70041737794   2929
computing           13239762.7706     1605.20887131426  8248
women's fashion     7390829.88819996  496.628805819108  14882
soghaat             825259.146800002  127.197772318126  6488
superstore          6084357.58039996  214.049519099383  28425
health & sports     1104386.8626      328.100672192513  3366
mobiles & tablets   125343868.807296  2341.69426284484  53527
men's fashion       4399831.14179965  251.72098757364   17479
beauty & grooming   3105087.06029999  261.151140479394  11890
kids & baby         860845.201        216.455921800352  3977
home & living       2981324.41749998  371.504600311524  8025
appliances          52185214.8427996  1795.03353201705  29072
school & education  120576.7432       200.626860565724  601
books               16022.9333        165.184879381443  97
*/

--q6
select 
    category_name_1,
    count(distinct sku) as distinct_skus,
    count(distinct increment_id) as total_orders
from orders
group by category_name_1;
/*
category_name_1     distinct_skus  total_orders
------------------  -------------  ------------
appliances          5127           47934
beauty & grooming   7631           29182
books               657            1546
computing           2229           14864
entertainment       1714           25481
health & sports     2660           12562
home & living       5591           18549
kids & baby         4549           11136
men's fashion       20067          67652
mobiles & tablets   7034           107967
others              663            28901
school & education  1668           2238
soghaat             1182           22551
superstore          4074           21810
women's fashion     19081          38874
*/

--q7
select
customer_id,
sum(grand_total) as total_spending,
avg(grand_total) as avg_order_value
from orders
group by customer_id
having count(distinct increment_id) > 5
order by total_spending desc;
/*

*/

--q8
select 
    sku,
    avg(price) as avg_sku_price
from orders
group by sku
having avg(price) > (select avg(price) from orders);
/*

*/

--q9
select 
    case 
        when grand_total < 500 then 'low'
        when grand_total between 500 and 1999 then 'medium'
        else 'high'
    end as order_class,
    count(distinct increment_id) as order_count,
    sum(grand_total) as total_sales
from orders
group by 
    case 
        when grand_total < 500 then 'low'
        when grand_total between 500 and 1999 then 'medium'
        else 'high'
    end;
/*
order_class order_count total_sales
----------- ----------- ----------------------
high        200071      4508057999.04164
low         63117       17602269.8790002
medium      140292      251661413.206498
*/

--q10
with categorysales as (
    select 
        category_name_1,
        sum(grand_total) as cat_total_sales
    from orders
    group by category_name_1
)
select *
from categorysales
where cat_total_sales > (select avg(cat_total_sales) from categorysales);
/*
category_name_1    cat_total_sales
-----------------  -----------------
entertainment      524423497.133492
mobiles & tablets  2294923390.13138
appliances         652456598.211504
*/

--q11
select 
    item_id,
    increment_id,
    sku,
    category_name_1,
    grand_total,
    rank() over (partition by category_name_1 order by grand_total desc) as order_rank
from orders;
/*

*/

--q12
select 
    payment_method,
    sum(grand_total) as total_sales,
    dense_rank() over (order by sum(grand_total) desc) as payment_rank
from orders
group by payment_method;
/*
payment_method                                     total_sales            payment_rank
-------------------------------------------------- ---------------------- --------------------
payaxis                                            1130761858.38952       1
cod                                                1044075546.62          2
easypay                                            905006612.87551        3
bankalfalah                                        653050102.292498       4
easypay_voucher                                    560518627.719996       5
jazzvoucher                                        176014033.520003       6
jazzwallet                                         126134668.779999       7
easypay_ma                                         107256689.920002       8
apg                                                24532497.14            9
ublcreditcard                                      20094202.88            10
mygateway                                          13372567.77            11
internetbanking                                    5930710.38             12
mcblite                                            5553205                13
cashatdoorstep                                     3309171                14
financesettlement                                  1524673                15
customercredit                                     124739.84              16
marketingexpense                                   61775                  17
productcredit                                      0                      18

*/

--q13
select 
    customer_id,
    item_id,
    grand_total,
    sum(grand_total) over (partition by customer_id order by item_id) as running_total
from orders;
/*

*/

--q14
with rankedorders as (
    select 
        customer_id,
        increment_id,
        grand_total,
        row_number() over (partition by customer_id order by grand_total desc) as rn
    from orders
)
select 
    customer_id,
    increment_id,
    grand_total
from rankedorders
where rn = 1;
/*

*/

--q15
select 
    item_id,
    category_name_1,
    grand_total,
    avg(grand_total) over (partition by category_name_1) as category_avg_grand_total,
    (grand_total - avg(grand_total) over (partition by category_name_1)) as diff_from_category_avg
from orders;
/*

*/

--q16
select 
    year,
    sum(grand_total) as total_sales,
    count(distinct increment_id) as total_orders
from orders
group by year
order by year desc;
/*
year        total_sales            total_orders
----------- ---------------------- ------------
2018        2051814505.4835        115130
2017        2121550386.02397       184595
2016        603956790.619962       103755
*/

--q17
select 
    year,
    month,
    sum(grand_total) as total_sales,
    count(distinct increment_id) as order_count
from orders
group by year, month
order by year desc, month asc;
/*
year        month       total_sales            order_count
----------- ----------- ---------------------- -----------
2018        1           88673937.9039998       8189
2018        2           319088857.54           19324
2018        3           420077063.867002       35109
2018        4           105246455.11           7720
2018        5           444859244.522492       19855
2018        6           253549588.32           9610
2018        7           265394503.6525         7496
2018        8           154924854.5675         7827
2017        1           118133518              9884
2017        2           88916072.6             8628
2017        3           139752631.52           13371
2017        4           151742944.51           12149
2017        5           245641023.810002       20546
2017        6           92057806.2260002       10526
2017        7           80603148.059           10020
2017        8           134032285.344          13655
2017        9           71935329.1805          5888
2017        10          118938937.4685         12735
2017        11          796617179.135515       57229
2017        12          83179510.1705002       9964
2016        7           39768164.27            6612
2016        8           47128319.7             9839
2016        9           79257951.6400014       12262
2016        10          86532340.7299999       10172
2016        11          262689709.520002       54139
2016        12          88580304.7600001       10731
*/

--q18
select 
    customer_id,
    min(created_at) as first_order_date,
    max(created_at) as latest_order_date
from orders
group by customer_id;
/*

*/

--q19
select 
    year,
    month,
    current_month_sales,
    previous_month_sales,
    round((current_month_sales - previous_month_sales) * 100.0 / previous_month_sales, 2) as mom_growth_percentage
from (
    select 
        year,
        month,
        sum(grand_total) as current_month_sales,
        lag(sum(grand_total)) over (order by year, month) as previous_month_sales
    from orders
    group by year, month
) as monthlydata;
/*
year        month       current_month_sales    previous_month_sales   mom_growth_percentage
----------- ----------- ---------------------- ---------------------- ----------------------
2016        7           39768164.27            null                   null
2016        8           47128319.7             39768164.27            18.51
2016        9           79257951.6400016       47128319.7             68.17
2016        10          86532340.7299998       79257951.6400016       9.18
2016        11          262689709.520002       86532340.7299998       203.57
2016        12          88580304.76            262689709.520002       -66.28
2017        1           118133518              88580304.76            33.36
2017        2           88916072.6             118133518              -24.73
2017        3           139752631.520001       88916072.6             57.17
2017        4           151742944.510001       139752631.520001       8.58
2017        5           245641023.810001       151742944.510001       61.88
2017        6           92057806.2259998       245641023.810001       -62.52
2017        7           80603148.059           92057806.2259998       -12.44
2017        8           134032285.343999       80603148.059           66.29
2017        9           71935329.1805001       134032285.343999       -46.33
2017        10          118938937.468502       71935329.1805001       65.34
2017        11          796617179.135502       118938937.468502       569.77
2017        12          83179510.1705005       796617179.135502       -89.56
2018        1           88673937.9039994       83179510.1705005       6.61
2018        2           319088857.54           88673937.9039994       259.85
2018        3           420077063.867002       319088857.54           31.65
2018        4           105246455.11           420077063.867002       -74.95
2018        5           444859244.522486       105246455.11           322.68
2018        6           253549588.320001       444859244.522486       -43
2018        7           265394503.6525         253549588.320001       4.67
2018        8           154924854.5675         265394503.6525         -41.62
*/

--q20
with monthlysales as (
    select 
        year,
        month,
        sum(grand_total) as total_monthly_sales
    from orders
    group by year, month
)
select 
    year,
    month,
    total_monthly_sales,
    dense_rank() over (partition by year order by total_monthly_sales desc) as month_rank
from monthlysales;
/*
year        month       total_monthly_sales    month_rank
----------- ----------- ---------------------- --------------------
2016        11          262689709.520002       1
2016        12          88580304.76            2
2016        10          86532340.7299998       3
2016        9           79257951.6400016       4
2016        8           47128319.7             5
2016        7           39768164.27            6
2017        11          796617179.135502       1
2017        5           245641023.810001       2
2017        4           151742944.510001       3
2017        3           139752631.520001       4
2017        8           134032285.343999       5
2017        10          118938937.468502       6
2017        1           118133518              7
2017        6           92057806.2259998       8
2017        2           88916072.6             9
2017        12          83179510.1705005       10
2017        7           80603148.059           11
2017        9           71935329.1805001       12
2018        5           444859244.522486       1
2018        3           420077063.867002       2
2018        2           319088857.54           3
2018        7           265394503.6525         4
2018        6           253549588.320001       5
2018        8           154924854.5675         6
2018        4           105246455.11           7
2018        1           88673937.9039994       8
*/
