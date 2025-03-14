-- CREATE TABLE information 
-- Brazilian E-commerce Public Dataset by Olist
-- https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce?select=olist_customers_dataset.csv

CREATE TABLE product_categories (
  product_category_id SERIAL PRIMARY KEY,
  product_category_name_spanish VARCHAR,
  product_category_name_english VARCHAR,
  created_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  updated_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  deleted_at TIMESTAMP DEFAULT NULL
);

CREATE TABLE products (
  product_id VARCHAR PRIMARY KEY,
  product_category_id INT REFERENCES product_categories(product_category_id),
  product_name_lenght INT,
  product_description_lenght INT,
  product_photo_qty INT,
  product_weight_g INT,
  product_length_cm INT,
  product_height_cm INT,
  product_width_cm INT,
  created_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  updated_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  deleted_at TIMESTAMP DEFAULT NULL
);

CREATE TABLE geolocations (
  geolocation_zip_code_prefix INT,
  geolocation_lat DECIMAL NOT NULL,
  geolocation_lng DECIMAL NOT NULL,
  geolocation_city VARCHAR NOT NULL,
  geolocation_state VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  updated_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  deleted_at TIMESTAMP DEFAULT NULL
);

CREATE TABLE customers (
  customer_id VARCHAR PRIMARY KEY,
  customer_unique_id VARCHAR NOT NULL,
  customer_zip_code_prefix INT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  updated_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  deleted_at TIMESTAMP DEFAULT NULL
);

CREATE TABLE sellers (
  seller_id VARCHAR PRIMARY KEY,
  seller_zip_code_prefix INT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  updated_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  deleted_at TIMESTAMP DEFAULT NULL
); 

CREATE TABLE order_status (
  order_status_id SMALLSERIAL PRIMARY KEY,
  order_status_name VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  updated_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  deleted_at TIMESTAMP DEFAULT NULL
);

CREATE TABLE orders (
  order_id VARCHAR PRIMARY KEY,
  customer_id VARCHAR NOT NULL REFERENCES customers(customer_id),
  order_status_id INT NOT NULL REFERENCES order_status(order_status_id),
  order_purchase_timestamp TIMESTAMP NOT NULL,
  order_approved_at TIMESTAMP,
  order_delivered_carrier_date TIMESTAMP,
  order_delivered_customer_date TIMESTAMP,
  order_estimated_delivery_date TIMESTAMP,
  created_at TIMESTAMP, -- Will be based on order_purchase_timestamp
  updated_at TIMESTAMP, -- Will be based on the latest date in row
  deleted_at TIMESTAMP DEFAULT NULL
);

CREATE OR REPLACE FUNCTION orders_set_time()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.created_at IS NULL THEN
  NEW.created_at := NEW.order_purchase_timestamp;
  END IF;

  IF NEW.updated_at IS NULL THEN
  NEW.updated_at := GREATEST(
    NEW.order_purchase_timestamp,
    NEW.order_approved_at,
    NEW.order_delivered_carrier_date,
    NEW.order_delivered_customer_date
  );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER orders_set_time
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION orders_set_time();

CREATE TABLE order_payment_methods (
  payment_method_id SMALLSERIAL PRIMARY KEY,
  payment_method_name VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  updated_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  deleted_at TIMESTAMP DEFAULT NULL    
);

CREATE TABLE order_payments (
  order_id VARCHAR NOT NULL REFERENCES orders(order_id),
  payment_sequential INT NOT NULL,
  payment_type_id INT NOT NULL REFERENCES order_payment_methods(payment_method_id),
  payment_installments INT NOT NULL,
  payment_value DECIMAL NOT NULL,
  created_at TIMESTAMP NOT NULL, -- Will be based on order_purchase_timestamp based on order_id
  updated_at TIMESTAMP NOT NULL,
  deleted_at TIMESTAMP DEFAULT NULL
);

CREATE TABLE order_items (
  order_id VARCHAR NOT NULL REFERENCES orders(order_id),
  order_item_id INT NOT NULL,
  product_id VARCHAR NOT NULL REFERENCES products(product_id),
  seller_id VARCHAR NOT NULL REFERENCES sellers(seller_id),
  shipping_limit_date TIMESTAMP NOT NULL,
  price DECIMAL NOT NULL,
  freight_value DECIMAL NOT NULL,
  created_at TIMESTAMP NOT NULL, -- Will be based on order_purchase_timestamp based on order_id
  updated_at TIMESTAMP NOT NULL,
  deleted_at TIMESTAMP DEFAULT NULL
);

CREATE OR REPLACE FUNCTION order_payments_items_set_time()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.created_at IS NULL THEN
  NEW.created_at := COALESCE(
    (SELECT created_at FROM orders WHERE orders.order_id = NEW.order_id),
    NOW()
  );
  END IF;

  IF NEW.updated_at IS NULL THEN
  NEW.updated_at := NEW.created_at;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER order_payments_set_time
BEFORE INSERT ON order_payments
FOR EACH ROW
EXECUTE FUNCTION order_payments_items_set_time();

CREATE TRIGGER order_items_set_time
BEFORE INSERT ON order_items
FOR EACH ROW
EXECUTE FUNCTION order_payments_items_set_time();

CREATE TABLE order_reviews (
  review_id VARCHAR NOT NULL,
  order_id VARCHAR NOT NULL REFERENCES orders(order_id),
  review_score SMALLINT NOT NULL,
  review_comment_title VARCHAR,
  review_comment_message VARCHAR,
  review_creation_date TIMESTAMP NOT NULL,
  review_answer_timestamp TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL, -- Will be based on review_creation_date
  updated_at TIMESTAMP NOT NULL,
  deleted_at TIMESTAMP DEFAULT NULL
);

CREATE OR REPLACE FUNCTION order_reviews_set_time()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.created_at IS NULL THEN
  NEW.created_at := NEW.review_answer_timestamp;
  END IF;

  IF NEW.updated_at IS NULL THEN
  NEW.updated_at := NEW.review_answer_timestamp;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER order_reviews_set_time
BEFORE INSERT ON order_reviews
FOR EACH ROW
EXECUTE FUNCTION order_reviews_set_time();

-- Marketing Funnel by Olist
-- https://www.kaggle.com/datasets/olistbr/marketing-funnel-olist?select=olist_closed_deals_dataset.csv

CREATE TABLE qualified_lead_origins (
  origin_id SMALLSERIAL PRIMARY KEY,
  origin_name VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  updated_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  deleted_at TIMESTAMP DEFAULT NULL  
);

CREATE TABLE qualified_leads (
  mql_id VARCHAR PRIMARY KEY,
  first_contact_date DATE NOT NULL,
  landing_page_id VARCHAR NOT NULL,
  origin_id SMALLINT REFERENCES qualified_lead_origins(origin_id),
  created_at TIMESTAMP NOT NULL, -- Will be based on first_contact_date
  updated_at TIMESTAMP NOT NULL,
  deleted_at TIMESTAMP DEFAULT NULL
);

CREATE OR REPLACE FUNCTION qualified_leads_set_time()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.created_at IS NULL THEN
  NEW.created_at := NEW.first_contact_date;
  END IF;

  IF NEW.updated_at IS NULL THEN
  NEW.updated_at := NEW.first_contact_date;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER qualified_leads_set_time
BEFORE INSERT ON qualified_leads
FOR EACH ROW
EXECUTE FUNCTION qualified_leads_set_time();

CREATE TABLE lead_business_segments (
  business_segment_id SMALLSERIAL PRIMARY KEY,
  business_segment_name VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  updated_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  deleted_at TIMESTAMP DEFAULT NULL  
);

CREATE TABLE lead_types (
  lead_type_id SMALLSERIAL PRIMARY KEY,
  lead_type_name VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  updated_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  deleted_at TIMESTAMP DEFAULT NULL  
);

CREATE TABLE lead_business_types (
  business_type_id SMALLSERIAL PRIMARY KEY,
  business_type_name VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  updated_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  deleted_at TIMESTAMP DEFAULT NULL
);

CREATE TABLE lead_behaviour_profiles (
  lead_behaviour_id SMALLSERIAL PRIMARY KEY,
  lead_behaviour_name VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  updated_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  deleted_at TIMESTAMP DEFAULT NULL  
);

CREATE TABLE closed_deals (
  mql_id VARCHAR REFERENCES qualified_leads(mql_id),
  seller_id VARCHAR UNIQUE NOT NULL REFERENCES sellers(seller_id),
  sdr_id VARCHAR NOT NULL,
  sr_id VARCHAR NOT NULL,
  won_date TIMESTAMP NOT NULL,
  business_segment_id INT REFERENCES lead_business_segments(business_segment_id),
  lead_type_id INT REFERENCES lead_types(lead_type_id),
  has_company BOOLEAN,
  has_gtin BOOLEAN,
  average_stock VARCHAR,
  business_type_id INT REFERENCES lead_business_types(business_type_id),
  declared_product_catalog_size INT,
  declared_monthly_revenue INT,
  created_at TIMESTAMP NOT NULL, -- Will be based on won_date
  updated_at TIMESTAMP NOT NULL,
  deleted_at TIMESTAMP DEFAULT NULL
);

-- Inconsistency between seller id in closed deals and seller
CREATE TABLE temp_closed_deals (
  mql_id VARCHAR,
  seller_id VARCHAR UNIQUE NOT NULL,
  sdr_id VARCHAR NOT NULL,
  sr_id VARCHAR NOT NULL,
  won_date TIMESTAMP NOT NULL,
  business_segment_id INT,
  lead_type_id INT,
  has_company BOOLEAN,
  has_gtin BOOLEAN,
  average_stock VARCHAR,
  business_type_id INT,
  declared_product_catalog_size INT,
  declared_monthly_revenue INT,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  deleted_at TIMESTAMP DEFAULT NULL
);

CREATE TABLE bridge_lead_behaviour_profiles (
  mql_id VARCHAR REFERENCES qualified_leads(mql_id),
  lead_behaviour_id INT REFERENCES lead_behaviour_profiles(lead_behaviour_id),
  won_date TIMESTAMP,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  deleted_at TIMESTAMP DEFAULT NULL
);

CREATE OR REPLACE FUNCTION closed_deals_set_time()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.created_at IS NULL THEN
  NEW.created_at := NEW.won_date;
  END IF;

  IF NEW.updated_at IS NULL THEN
  NEW.updated_at := NEW.won_date;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER closed_deals_set_time
BEFORE INSERT ON temp_closed_deals
FOR EACH ROW
EXECUTE FUNCTION closed_deals_set_time();

CREATE TRIGGER lead_behaviours_set_time
BEFORE INSERT ON bridge_lead_behaviour_profiles
FOR EACH ROW
EXECUTE FUNCTION closed_deals_set_time();

ALTER TABLE product_categories REPLICA IDENTITY FULL;
ALTER TABLE products REPLICA IDENTITY FULL;
ALTER TABLE geolocations REPLICA IDENTITY FULL;
ALTER TABLE customers REPLICA IDENTITY FULL;
ALTER TABLE sellers REPLICA IDENTITY FULL;
ALTER TABLE order_status REPLICA IDENTITY FULL;
ALTER TABLE orders REPLICA IDENTITY FULL;
ALTER TABLE order_payment_methods REPLICA IDENTITY FULL;
ALTER TABLE order_payments REPLICA IDENTITY FULL;
ALTER TABLE order_items REPLICA IDENTITY FULL;
ALTER TABLE order_reviews REPLICA IDENTITY FULL;
ALTER TABLE qualified_lead_origins REPLICA IDENTITY FULL;
ALTER TABLE qualified_leads REPLICA IDENTITY FULL;
ALTER TABLE lead_business_segments REPLICA IDENTITY FULL;
ALTER TABLE lead_types REPLICA IDENTITY FULL;
ALTER TABLE lead_business_types REPLICA IDENTITY FULL;
ALTER TABLE lead_behaviour_profiles REPLICA IDENTITY FULL;
ALTER TABLE closed_deals REPLICA IDENTITY FULL;
ALTER TABLE bridge_lead_behaviour_profiles REPLICA IDENTITY FULL;
