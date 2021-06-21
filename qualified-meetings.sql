SELECT 
    pipedrive_deals.pipedrive_id AS 'deal_id',
    pipedrive_deals.title AS 'deal_title',
    date_format(pipedrive_activities.marked_as_done_time, "%d/%m/%Y") AS 'marked_as_done',
    pipedrive_activities.user_id AS 'sdr',
    pipedrive_activities.person_name AS 'person',
    pipedrive_deals.org_name as 'org'
FROM
    pipedrive_deals
        INNER JOIN
    pipedrive_activities ON pipedrive_activities.deal_id = pipedrive_deals.pipedrive_id
        AND pipedrive_deals.salesfarm_ref_id = pipedrive_activities.salesfarm_ref_id
        INNER JOIN
    activity_types ON pipedrive_activities.type = activity_types.key_string
        AND pipedrive_activities.salesfarm_ref_id = activity_types.salesfarm_ref_id
WHERE
    pipedrive_deals.salesfarm_ref_id = 205
        AND pipedrive_activities.done = 1
        AND pipedrive_activities.marked_as_done_time BETWEEN '2021-05-01 00:00:00' AND '2021-05-31 23:59:59'
        AND (activity_types.icon_key = 'finish'
        OR activity_types.icon_key = 'loop');
