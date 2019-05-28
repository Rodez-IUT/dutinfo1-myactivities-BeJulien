package myactivities.myactivities.model;

import org.apache.ibatis.annotations.*;
import org.apache.ibatis.mapping.StatementType;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Mapper @Service
public interface ActivityDAOService {

    @Select(value= "{CALL add_activity(" +
            "#{title, mode=IN, jdbcType=VARCHAR, javaType=String}," +
            "#{description, mode=IN, jdbcType=VARCHAR, javaType=String}," +
            "#{ownerId, mode=IN, jdbcType=BIGINT, javaType=Long})}")
    @Results(id = "activity", value = {
            @Result(property = "creationDate", column = "creation_date"),
            @Result(property = "modificationDate", column = "modification_date"),
            @Result(property = "ownerId", column = "owner_id")
    })
    @Options(statementType = StatementType.CALLABLE)
    public Activity addActivity(String title, String description, Long ownerId);

    @Select(value = "select act.*, username from activity act " +
            "left join \"user\" owner " +
            "on act.owner_id = owner.id where act.id =#{id}")
    @ResultMap("activity")
    public Activity getActivityForId(Long id);

    @Insert(value= "{CALL find_all_activities(#{result,mode=OUT, jdbcType=OTHER, javaType=java.sql.ResultSet, resultMap=activity})}")
    @Options(statementType = StatementType.CALLABLE)
    public void findAllActivitiesWithProcedureCall(Map<String,List<Activity>> parameters);
    
    @Select(value = "select * from activity")
    @ResultMap("activity")
    public List<Activity> findAllActivities();
    
}