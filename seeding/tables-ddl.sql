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
  customer_city VARCHAR NOT NULL,
  customer_state VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  updated_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  deleted_at TIMESTAMP DEFAULT NULL
);

CREATE TABLE sellers (
  seller_id VARCHAR PRIMARY KEY,
  seller_zip_code_prefix INT NOT NULL,
  seller_city VARCHAR NOT NULL,
  seller_state VARCHAR NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  updated_at TIMESTAMP NOT NULL DEFAULT '2015-01-01 12:00:00',
  deleted_at TIMESTAMP DEFAULT NULL
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

CREATE TABLE order_payments (
  order_id VARCHAR NOT NULL REFERENCES orders(order_id),
  payment_sequential INT NOT NULL,
  payment_type VARCHAR NOT NULL,
  payment_installments DECIMAL NOT NULL,
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
  NEW.created_at := NEW.review_creation_date;
  END IF;

  IF NEW.updated_at IS NULL THEN
  NEW.updated_at := NEW.review_creation_date;
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
CREATE TABLE qualified_leads (
  mql_id VARCHAR PRIMARY KEY,
  first_contact_date DATE NOT NULL,
  landing_page_id VARCHAR NOT NULL,
  origin VARCHAR,
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
  business_segment VARCHAR,
  lead_type VARCHAR,
  lead_behaviour_profile VARCHAR,
  has_company BOOLEAN,
  has_gtin BOOLEAN,
  average_stock VARCHAR,
  business_type VARCHAR,
  declared_product_catalog_size DECIMAL,
  declared_monthly_revenue DECIMAL,
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
