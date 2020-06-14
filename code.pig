-- Load order data from CSV-file
orders =	LOAD 'diplomacy/orders.csv'
			USING PigStorage(',')
            AS (
            	game_id:chararray,
                unit_id:chararray,
                unit_order:chararray,
                location:chararray,
                target:chararray,
                target_dest:chararray,
                success:chararray,
                reason:chararray,
                turn_num:chararray
            );

-- Remove redundant double quotations for better usability
orders_clean =	FOREACH orders GENERATE
				REPLACE($0, '"', '') AS (game_id:chararray),
                REPLACE($1, '"', '') AS (unit_id:chararray),
                REPLACE($2, '"', '') AS (unit_order:chararray),
                REPLACE($3, '"', '') AS (location:chararray),
                REPLACE($4, '"', '') AS (target:chararray),
                REPLACE($5, '"', '') AS (target_dest:chararray),
                REPLACE($6, '"', '') AS (success:chararray),
                REPLACE($7, '"', '') AS (reason:chararray),
                REPLACE($8, '"', '') AS (turn_num:chararray);

-- Filter data by target 'Holland'
orders_filtered = FILTER orders_clean BY target == 'Holland';

-- Group data by location and target
orders_grouped = GROUP orders_filtered BY (location, target);

-- Count tuples per location
orders_count =	FOREACH orders_grouped GENERATE
				FLATTEN(group) AS (location, target), COUNT($1);

-- Order countries alphabetically
orders_alphabetical = ORDER orders_count BY location;

DUMP orders_alphabetical;