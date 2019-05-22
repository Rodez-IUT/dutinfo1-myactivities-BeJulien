package myactivities.myactivities.model;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.transaction.annotation.Transactional;


import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import static org.hamcrest.CoreMatchers.*;
import static org.hamcrest.MatcherAssert.assertThat;

@RunWith(SpringRunner.class)
@SpringBootTest
@Transactional
public class ActivityDAOServiceTest {

    Logger logger = LoggerFactory.getLogger(ActivityDAOServiceTest.class);

    @Autowired
    private ActivityDAOService activityService;

    @Test
    @Transactional
    public void testAddNewActivity() {

        // Quand on ajoute une activité avec un titre
        Activity activity = activityService.addActivity("Une activité nouvelle", "héhé", null);

        // alors on récupère un id non null pour cette activité
        assertThat(activity.getId(), notNullValue());
        assertThat(activity.getTitle(), is(equalTo("Une activité nouvelle")));
        assertThat(activity.getCreationDate(), is(notNullValue()));
        assertThat(activity.getOwnerId(), is(notNullValue()));
        logger.error(activity.toString());


        // quand on récupère l'activité pour cette id
        Activity fetchedActivity = activityService.getActivityForId(activity.getId());

        // alors on récupère les données attendues
        assertThat(fetchedActivity.getId(), is(equalTo(activity.getId())));
        assertThat(fetchedActivity.getTitle(), is(equalTo(activity.getTitle())));
        assertThat(fetchedActivity.getCreationDate(), is(notNullValue()));
        assertThat(fetchedActivity.getOwnerId(), is(notNullValue()));
        assertThat(fetchedActivity.getUsername(), is(equalTo("Default Owner")));
        logger.error(fetchedActivity.toString());
    }


    @Test
    @Transactional
    public void testFindAllActivitiesWithProcedureCall() {

        // Etant donné les activités d'initialisation et une activité en plus
        Activity activity = activityService.addActivity("Une activité nouvelle", "héhé", null);

        // quand on récupère toutes les activités
        Map<String, List<Activity>> param = new HashMap<>();
        activityService.findAllActivitiesWithProcedureCall(param);

        // alors on peut parcourir l'ensemble des activités
        Iterator<Activity> iterator = param.get("result").iterator();
        assertThat(iterator.hasNext(),is(true));
        iterator.forEachRemaining(act -> {
            assertThat(act.getId(), is(notNullValue()));
            logger.error(act.toString());
        });

    }

    @Test
    @Transactional
    public void testFindAllActivitiesWithSQLCall() {

        // Etant donné les activités d'initialisation et une activité en plus
        Activity activity = activityService.addActivity("Une activité nouvelle", "héhé", null);

        // quand on récupère toutes les activités via un curseur
        List<Activity> activityList = activityService.findAllActivities();

        // alors on peut parcourir l'ensemble des activités
        Iterator<Activity> iterator = activityList.iterator();
        assertThat(iterator.hasNext(),is(true));
        iterator.forEachRemaining(act -> {
            assertThat(act.getId(), is(notNullValue()));
            logger.error(act.toString());
        });

    }

}