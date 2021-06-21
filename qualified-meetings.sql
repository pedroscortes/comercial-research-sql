-- on this query we are looking for meetings scheduled by any sdr that happened and the closer considered that it fit the icp
-- we select columns like the deal id, title and some information about the organization for analysis purpose only
SELECT 
    pipedrive_deals.pipedrive_id AS 'deal_id',
    pipedrive_deals.title AS 'deal_title',
    pipedrive_activities.user_id AS 'closer',
    pipedrive_activities.person_name AS 'person',
    pipedrive_deals.org_name as 'org',
-- the webhook stores the time as Y-m-d xx:xx:xx as a standart but we choose to format it to the brazilian standart    
    date_format(pipedrive_activities.marked_as_done_time, "%d/%m/%Y") AS 'marked_as_done'
FROM
    pipedrive_deals
-- this join is necessary because we are looking for activities from the perspective of the deal, the meeting is a special activity that happens just one time per lead         
        INNER JOIN
    pipedrive_activities ON pipedrive_activities.deal_id = pipedrive_deals.pipedrive_id
-- you should use composite key here because we wanna be sure any line will be duplicated and we are looking to the crm of a specific customer     
        AND pipedrive_deals.salesfarm_ref_id = pipedrive_activities.salesfarm_ref_id
-- this other join enable us to look for the activity from the icon perspective, minimizing errors        
        INNER JOIN
    activity_types ON pipedrive_activities.type = activity_types.key_string
        AND pipedrive_activities.salesfarm_ref_id = activity_types.salesfarm_ref_id
WHERE
    pipedrive_deals.salesfarm_ref_id = 205
        AND pipedrive_activities.done = 1
        AND pipedrive_activities.marked_as_done_time BETWEEN '2021-05-01 00:00:00' AND '2021-05-31 23:59:59'
        AND (activity_types.icon_key = 'finish'
        OR activity_types.icon_key = 'loop');
