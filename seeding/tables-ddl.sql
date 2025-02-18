-- CREATE TABLE information 
-- Brazilian E-commerce Public Dataset by Olist
-- https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce?select=olist_customers_dataset.csv
CREATE TABLE products (
  product_id varchar PRIMARY KEY,
  product_category_name varchar,
  product_name_lenght int,
  product_description_lenght int,
  product_photo_qty int,
  product_weight_g int,
  product_length_cm int,
  product_height_cm int,
  product_width_cm int
);

CREATE TABLE geolocations (
  geolocation_zip_code_prefix int,
  geolocation_lat float NOT NULL,
  geolocation_lng float NOT NULL,
  geolocation_city varchar NOT NULL,
  geolocation_state varchar NOT NULL
);

CREATE TABLE customers (
  customer_id varchar PRIMARY KEY,
  customer_unique_id varchar NOT NULL,
  customer_zip_code_prefix int NOT NULL,
  customer_city varchar NOT NULL,
  customer_state varchar NOT NULL
);

CREATE TABLE sellers (
  seller_id varchar PRIMARY KEY,
  seller_zip_code_prefix integer NOT NULL,
  seller_city varchar NOT NULL,
  seller_state varchar NOT NULL
); 

CREATE TABLE orders (
  order_id varchar PRIMARY KEY,
  customer_id varchar NOT NULL REFERENCES customers(customer_id),
  order_status varchar NOT NULL,
  order_purchase_timestamp timestamp NOT NULL,
  order_approved_at timestamp,
  order_delivered_carrier_date timestamp,
  order_delivered_customer_date timestamp,
  order_estimated_delivery_date timestamp
);

CREATE TABLE order_payments (
  order_id varchar NOT NULL REFERENCES orders(order_id),
  payment_sequential int NOT NULL,
  payment_type varchar NOT NULL,
  payment_installments int NOT NULL,
  payment_value float NOT NULL
);

CREATE TABLE order_reviews (
  review_id varchar NOT NULL,
  order_id varchar NOT NULL REFERENCES orders(order_id),
  review_score int NOT NULL,
  review_comment_title varchar,
  review_comment_message varchar,
  review_creation_date timestamp NOT NULL,
  review_answer_timestamp timestamp NOT NULL
);

CREATE TABLE order_items (
  order_id varchar NOT NULL REFERENCES orders(order_id),
  order_item_id int NOT NULL,
  product_id varchar NOT NULL REFERENCES products(product_id),
  seller_id varchar NOT NULL REFERENCES sellers(seller_id),
  shipping_limit_date timestamp NOT NULL,
  price float NOT NULL,
  freight_value float NOT NULL
);

-- Marketing Funnel by Olist
-- https://www.kaggle.com/datasets/olistbr/marketing-funnel-olist?select=olist_closed_deals_dataset.csv
CREATE TABLE qualified_leads (
  mql_id varchar PRIMARY KEY,
  first_contact_date date NOT NULL,
  landing_page_id varchar NOT NULL,
  origin varchar
);

CREATE TABLE closed_deals (
  mql_id varchar REFERENCES qualified_leads(mql_id),
  seller_id varchar UNIQUE NOT NULL REFERENCES sellers(seller_id),
  sdr_id varchar NOT NULL,
  sr_id varchar NOT NULL,
  won_date timestamp NOT NULL,
  business_segment varchar,
  lead_type varchar,
  lead_behaviour_profile varchar,
  has_company bool,
  has_gtin bool,
  average_stock varchar,
  business_type varchar,
  declared_product_catalog_size float,
  declared_monthly_revenue float
);

-- Inconsistency between seller id in closed deals and seller
CREATE TABLE temp_closed_deals (
  mql_id varchar,
  seller_id varchar UNIQUE NOT NULL,
  sdr_id varchar NOT NULL,
  sr_id varchar NOT NULL,
  won_date timestamp NOT NULL,
  business_segment varchar,
  lead_type varchar,
  lead_behaviour_profile varchar,
  has_company bool,
  has_gtin bool,
  average_stock varchar,
  business_type varchar,
  declared_product_catalog_size float,
  declared_monthly_revenue float
);

-- DROP TABLE information
-- Please use CASCADE to remove the table and its dependencies
-- For example:
-- DROP TABLE orders CASCADE;
-- DROP TABLE qualified_leads CASCADE;