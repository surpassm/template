package ${serverImpl};

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import ${entity}.${modelName};
import ${mappers}.${modelName}${mapper?cap_first};
import ${server}.${modelName}${service?cap_first};
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tk.mybatis.mapper.entity.Example;
import tk.mybatis.mapper.weekend.WeekendSqls;
import lombok.extern.slf4j.Slf4j;
import com.github.surpassm.common.jackson.Result;
import com.github.surpassm.common.jackson.Tips;
import com.github.surpassm.config.BeanConfig;
import com.github.surpassm.tool.util.ValidateUtil;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.github.surpassm.common.jackson.Result.fail;
import static com.github.surpassm.common.jackson.Result.ok;


/**
  * @author mc
  * Create date ${.now?string("yyyy-MM-dd HH:mm:ss")}
  * Version 1.0
  * Description ${comment}实现类
  */
@Slf4j
@Service
@Transactional(rollbackFor={RuntimeException.class, Exception.class})
public class ${modelName}ServiceImpl implements ${modelName}Service {
    @Resource
    private ${modelName}Mapper ${fieldName}Mapper;
    @Resource
	private BeanConfig beanConfig;

    @Override
    public Result insert(String accessToken,${modelName} ${fieldName}) {
        if (${fieldName} == null){
            return fail(Tips.PARAMETER_ERROR.msg);
        }
        UserInfo loginUserInfo = beanConfig.getAccessToken(accessToken);
        ${fieldName}.setCreateUserId(loginUserInfo.getId());
        ${fieldName}.setCreateTime(LocalDateTime.now());
        ${fieldName}.setIsDelete(0);
        ${fieldName}Mapper.insert(${fieldName});
        return ok();
    }

    @Override
    public Result update(String accessToken,${modelName} ${fieldName}) {
        if (${fieldName} == null){
            return fail(Tips.PARAMETER_ERROR.msg);
        }
        UserInfo loginUserInfo = beanConfig.getAccessToken(accessToken);
        ${fieldName}.setUpdateUserId(loginUserInfo.getId());
        ${fieldName}.setUpdateTime(LocalDateTime.now());
        ${fieldName}Mapper.updateByPrimaryKeySelective(${fieldName});
        return ok();
    }

    @Override
    public Result deleteGetById(String accessToken,${primaryKey.columnType} ${primaryKey.changeColumnName}){
        if (${primaryKey.changeColumnName} == null){
            return fail(Tips.PARAMETER_ERROR.msg);
        }
        ${modelName} ${fieldName} = ${fieldName}Mapper.selectByPrimaryKey(${primaryKey.changeColumnName});
        if(${fieldName} == null){
            return fail(Tips.MSG_NOT.msg);
        }
        UserInfo loginUserInfo = beanConfig.getAccessToken(accessToken);
        ${fieldName}.setDeleteUserId(loginUserInfo.getId());
        ${fieldName}.setDeleteTime(LocalDateTime.now());
        ${fieldName}.setIsDelete(1);
        ${fieldName}Mapper.updateByPrimaryKeySelective(${fieldName});
        return ok();
    }


    @Override
    public Result findById(String accessToken,${primaryKey.columnType} ${primaryKey.changeColumnName}) {
        if (${primaryKey.changeColumnName} == null){
            return fail(Tips.PARAMETER_ERROR.msg);
        }
		${modelName} ${fieldName} = ${fieldName}Mapper.selectByPrimaryKey(${primaryKey.changeColumnName});
        if (${fieldName} == null){
			return fail(Tips.MSG_NOT.msg);
		}
        return ok(${fieldName});

    }

    @Override
    public Result pageQuery(String accessToken,Integer page, Integer size, String sort, ${modelName} ${fieldName}) {
        page = null  == page ? 1 : page;
        size = null  == size ? 10 : size;
        if (sort != null && !"".equals(sort.trim())){
			PageHelper.startPage(page, size,sort);
		}else {
			PageHelper.startPage(page, size);
		}
        Example.Builder builder = new Example.Builder(${modelName}.class);
        builder.where(WeekendSqls.<${modelName}>custom().andEqualTo(${modelName}::getIsDelete, 0));
        if(${fieldName} != null){
<#list columnClassList as columnClass>
    <#if columnClass.columnType == "String" >
        if (${fieldName}.get${columnClass.changeColumnName?cap_first}() != null && !"".equals(${fieldName}.get${columnClass.changeColumnName?cap_first}().trim())){
            builder.where(WeekendSqls.<${modelName}>custom().andLike(${modelName}::get${columnClass.changeColumnName?cap_first},"%"+${fieldName}.get${columnClass.changeColumnName?cap_first}()+"%"));
        }
    <#elseif columnClass.columnType == "Integer">
        if (${fieldName}.get${columnClass.changeColumnName?cap_first}() != null){
            builder.where(WeekendSqls.<${modelName}>custom().andEqualTo(${modelName}::get${columnClass.changeColumnName?cap_first},${fieldName}.get${columnClass.changeColumnName?cap_first}()));
        }
    <#else>
        if (${fieldName}.get${columnClass.changeColumnName?cap_first}() != null){
            builder.where(WeekendSqls.<${modelName}>custom().andEqualTo(${modelName}::get${columnClass.changeColumnName?cap_first},${fieldName}.get${columnClass.changeColumnName?cap_first}()));
        }
    </#if>
</#list>
        }
        Page<${modelName}> all = (Page<${modelName}>) ${fieldName}Mapper.selectByExample(builder.build());
        Map<String, Object> map = new HashMap<>(16);
        map.put("total",all.getTotal());
        map.put("rows",all.getResult());
        return ok(map);
    }
}

