-- 01_staging_schema.sql
-- Creacion de base de datos y esquema de staging para los datos crudos
-- Todos los atributos de las tablas los guardo en nvarchar para evitar errores de carga
-- y seran transformados una vez insertados en sus respectivas dimensiones

CREATE DATABASE OlistDW;
GO

USE OlistDW;
GO

CREATE SCHEMA staging;
GO

CREATE TABLE staging.customers (
    customer_id                 NVARCHAR(50),
    customer_unique_id          NVARCHAR(50),
    customer_zip_code_prefix    NVARCHAR(10),
    customer_city                NVARCHAR(100),
    customer_state                NVARCHAR(10)
);
GO

CREATE TABLE staging.order_items (
    order_id              NVARCHAR(50),
    order_item_id          NVARCHAR(10),
    product_id             NVARCHAR(50),
    seller_id              NVARCHAR(50),
    shipping_limit_date    NVARCHAR(50),
    price                   NVARCHAR(50),
    freight_value           NVARCHAR(50)
);
GO

CREATE TABLE staging.geolocation (
    geolocation_zip_code_prefix    NVARCHAR(100),
    geolocation_lat                 NVARCHAR(100),
    geolocation_lng                  NVARCHAR(100),
    geolocation_city                  NVARCHAR(100),
    geolocation_state                  NVARCHAR(100)
);
GO

CREATE TABLE staging.orders (
    order_id                          NVARCHAR(100),
    customer_id                        NVARCHAR(100),
    order_status                        NVARCHAR(50),
    order_purchase_timestamp             NVARCHAR(100),
    order_approved_at                     NVARCHAR(100),
    order_delivered_carrier_date           NVARCHAR(100),
    order_delivered_customer_date           NVARCHAR(100),
    order_estimated_delivery_date            NVARCHAR(100)
);
GO

CREATE TABLE staging.order_payments (
    order_id                  NVARCHAR(100),
    payment_sequential          NVARCHAR(100),
    payment_type                  NVARCHAR(100),
    payment_installments            NVARCHAR(100),
    payment_value                     NVARCHAR(100)
);
GO

CREATE TABLE staging.order_reviews (
    review_id                  NVARCHAR(100),
    order_id                     NVARCHAR(100),
    review_score                   NVARCHAR(100),
    review_comment_title             NVARCHAR(100),
    review_comment_message             NVARCHAR(MAX),
    review_creation_date                 NVARCHAR(100),
    review_answer_timestamp                NVARCHAR(100)
);
GO

CREATE TABLE staging.products (
    product_id                       NVARCHAR(100),
    product_category_name              NVARCHAR(100),
    product_name_lenght                  NVARCHAR(100),
    product_description_lenght             NVARCHAR(100),
    product_photos_qty                       NVARCHAR(100),
    product_weight_g                           NVARCHAR(100),
    product_length_cm                           NVARCHAR(100),
    product_height_cm                          NVARCHAR(100),
    product_width_cm                          NVARCHAR(100)
);
GO

CREATE TABLE staging.sellers (
    seller_id                  NVARCHAR(100),
    seller_zip_code_prefix       NVARCHAR(100),
    seller_city                    NVARCHAR(100),
    seller_state                     NVARCHAR(100)
);
GO

CREATE TABLE staging.product_category_name_translation (
    product_category_name            NVARCHAR(100),
    product_category_name_english    NVARCHAR(100)
);
GO
