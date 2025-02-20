-- CREATE TABLE information 
-- Brazilian E-commerce Public Dataset by Olist
-- https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce?select=olist_customers_dataset.csv
CREATE TABLE products (
  product_id VARCHAR PRIMARY KEY,
  product_category_name VARCHAR,
  product_name_lenght INT,
  product_description_lenght INT,
  product_photo_qty INT,
  product_weight_g INT,
  product_length_cm INT,
  product_height_cm INT,
  product_width_cm INT,
  created_at TIMESTAMP DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMP DEFAULT NOW() NOT NULL,
  deleted_at TIMESTAMP
);

CREATE TABLE geolocations (
  geolocation_zip_code_prefix INT,
  geolocation_lat DECIMAL NOT NULL,
  geolocation_lng DECIMAL NOT NULL,
  geolocation_city VARCHAR NOT NULL,
  geolocation_state VARCHAR NOT NULL,
  created_at TIMESTAMP DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMP DEFAULT NOW() NOT NULL,
  deleted_at TIMESTAMP
);

CREATE TABLE customers (
  customer_id VARCHAR PRIMARY KEY,
  customer_unique_id VARCHAR NOT NULL,
  customer_zip_code_prefix INT NOT NULL,
  customer_city VARCHAR NOT NULL,
  customer_state VARCHAR NOT NULL,
  created_at TIMESTAMP DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMP DEFAULT NOW() NOT NULL,
  deleted_at TIMESTAMP
);

CREATE TABLE sellers (
  seller_id VARCHAR PRIMARY KEY,
  seller_zip_code_prefix INT NOT NULL,
  seller_city VARCHAR NOT NULL,
  seller_state VARCHAR NOT NULL,
  created_at TIMESTAMP DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMP DEFAULT NOW() NOT NULL,
  deleted_at TIMESTAMP
); 

CREATE TABLE orders (
  order_id VARCHAR PRIMARY KEY,
  customer_id VARCHAR NOT NULL REFERENCES customers(customer_id),
  order_status VARCHAR NOT NULL,
  order_purchase_timestamp TIMESTAMP NOT NULL,
  order_approved_at TIMESTAMP,
  order_delivered_carrier_date TIMESTAMP,
  order_delivered_customer_date TIMESTAMP,
  order_estimated_delivery_date TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMP DEFAULT NOW() NOT NULL,
  deleted_at TIMESTAMP
);

CREATE TABLE order_payments (
  order_id VARCHAR NOT NULL REFERENCES orders(order_id),
  payment_sequential INT NOT NULL,
  payment_type VARCHAR NOT NULL,
  payment_installments DECIMAL NOT NULL,
  payment_value DECIMAL NOT NULL,
  created_at TIMESTAMP DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMP DEFAULT NOW() NOT NULL,
  deleted_at TIMESTAMP
);

CREATE TABLE order_reviews (
  review_id VARCHAR NOT NULL,
  order_id VARCHAR NOT NULL REFERENCES orders(order_id),
  review_score SMALLINT NOT NULL,
  review_comment_title VARCHAR,
  review_comment_message VARCHAR,
  review_creation_date TIMESTAMP NOT NULL,
  review_answer_timestamp TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMP DEFAULT NOW() NOT NULL,
  deleted_at TIMESTAMP
);

CREATE TABLE order_items (
  order_id VARCHAR NOT NULL REFERENCES orders(order_id),
  order_item_id INT NOT NULL,
  product_id VARCHAR NOT NULL REFERENCES products(product_id),
  seller_id VARCHAR NOT NULL REFERENCES sellers(seller_id),
  shipping_limit_date TIMESTAMP NOT NULL,
  price DECIMAL NOT NULL,
  freight_value DECIMAL NOT NULL,
  created_at TIMESTAMP DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMP DEFAULT NOW() NOT NULL,
  deleted_at TIMESTAMP
);

-- Marketing Funnel by Olist
-- https://www.kaggle.com/datasets/olistbr/marketing-funnel-olist?select=olist_closed_deals_dataset.csv
CREATE TABLE qualified_leads (
  mql_id VARCHAR PRIMARY KEY,
  first_contact_date DATE NOT NULL,
  landing_page_id VARCHAR NOT NULL,
  origin VARCHAR,
  created_at TIMESTAMP DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMP DEFAULT NOW() NOT NULL,
  deleted_at TIMESTAMP
);

CREATE TABLE closed_deals (
  mql_id VARCHAR REFERENCES qualified_leads(mql_id),
  seller_id VARCHAR UNIQUE NOT NULL REFERENCES sellers(seller_id),
  sdr_id VARCHAR NOT NULL,
  sr_id VARCHAR NOT NULL,
  won_date TIMESTAMP NOT NULL,
  business_segment VARCHAR,
  lead_type VARCHAR,
  lead_behaviour_profile VARCHAR,
  has_company BOOLEAN,
  has_gtin BOOLEAN,
  average_stock VARCHAR,
  business_type VARCHAR,
  declared_product_catalog_size DECIMAL,
  declared_monthly_revenue DECIMAL,
  created_at TIMESTAMP DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMP DEFAULT NOW() NOT NULL,
  deleted_at TIMESTAMP
);

-- Inconsistency between seller id in closed deals and seller
CREATE TABLE temp_closed_deals (
  mql_id VARCHAR,
  seller_id VARCHAR UNIQUE NOT NULL,
  sdr_id VARCHAR NOT NULL,
  sr_id VARCHAR NOT NULL,
  won_date TIMESTAMP NOT NULL,
  business_segment VARCHAR,
  lead_type VARCHAR,
  lead_behaviour_profile VARCHAR,
  has_company BOOLEAN,
  has_gtin BOOLEAN,
  average_stock VARCHAR,
  business_type VARCHAR,
  declared_product_catalog_size DECIMAL,
  declared_monthly_revenue DECIMAL,
  created_at TIMESTAMP DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMP DEFAULT NOW() NOT NULL,
  deleted_at TIMESTAMP
);

-- DROP TABLE information
-- Please use CASCADE to remove the table and its dependencies
-- For example:
-- DROP TABLE orders CASCADE;
-- DROP TABLE qualified_leads CASCADE;