-- in this query we select the add_time and the marked_as_done_time of the first activity done in the deal to find the lead time of the first follow up
-- we use a sub query so we can extract attributes specific from the first activity of the deal
-- in this databank specifically we have different time zones (the add_time column for example is stored in GMT+0, but data_entrada uses GMT - 03:00)
SELECT 
    pipedrive_deals.pipedrive_id,
    pipedrive_deals.title,
    pipedrive_deals.add_time,
    inner_query.marked_as_done_time,
    DATEDIFF(inner_query.marked_as_done_time,
            pipedrive_deals.add_time) AS diff,
    pipedrive_times_in_stages.data_entrada
FROM
    pipedrive_deals
        INNER JOIN
    pipedrive_stages ON pipedrive_stages.stage_id = pipedrive_deals.stage_id
        AND pipedrive_stages.company_ref_id = pipedrive_deals.company_ref_id
        INNER JOIN
    (SELECT 
        MIN(pipedrive_activities.marked_as_done_time) AS marked_as_done_time,
            pipedrive_activities.deal_id,
            pipedrive_activities.company_ref_id
    FROM
        pipedrive_activities
    WHERE
        pipedrive_activities.company_ref_id = --insert id
            AND marked_as_done_time IS NOT NULL
            AND pipedrive_activities.deleted_at IS NULL
    GROUP BY pipedrive_activities.deal_id) AS inner_query ON inner_query.deal_id = pipedrive_deals.pipedrive_id
        AND inner_query.company_ref_id = pipedrive_deals.company_ref_id
        INNER JOIN
    pipedrive_times_in_stages ON pipedrive_times_in_stages.stage = pipedrive_deals.stage_id
        AND pipedrive_times_in_stages.company_ref_id = pipedrive_deals.company_ref_id
        and pipedrive_times_in_stages.stage = --insert stage_id
        and pipedrive_deals.pipedrive_id = pipedrive_times_in_stages.deal_id
WHERE
    pipedrive_deals.company_ref_id = --insert id
        AND pipedrive_stages.pipeline_id = 1
        AND pipedrive_deals.deleted_at IS NULL
GROUP BY pipedrive_deals.pipedrive_id;
