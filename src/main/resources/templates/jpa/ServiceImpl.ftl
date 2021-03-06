package ${packageName}.service.impl;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.ArrayList;
import java.util.List;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;
import com.github.surpassm.common.jackson.Result;
import java.time.LocalDateTime;

import ${entity}.${modelName};
import ${mappers}.${modelName}${mapper?cap_first};
import ${server}.${modelName}${service?cap_first};

import static com.github.surpassm.common.jackson.Result.*;

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
    private ${modelName}Repository ${fieldName}Repository;
    @Resource
	private BeanConfig beanConfig;

    @Override
    public Result insert(String accessToken, ${modelName} ${fieldName}) {

        if (!Optional.ofNullable(${fieldName}).isPresent()){
            return fail(Tips.PARAMETER_ERROR.msg);
        }
        UserInfo loginUser = beanConfig.getAccessToken(accessToken);
        ${fieldName}.setCreateTime(LocalDateTime.now());
        ${fieldName}.setCreateUserId(loginUser.getId());
        ${fieldName}.setIsDelete(0);
        ${fieldName}Repository.save(${fieldName});
        return ok();
    }

    @Override
    public Result update(String accessToken, ${modelName} ${fieldName}) {
        if (!Optional.ofNullable(${fieldName}).isPresent()){
            return fail(Tips.PARAMETER_ERROR.msg);
        }
        UserInfo loginUser = beanConfig.getAccessToken(accessToken);
        ${fieldName}.setUpdateTime(LocalDateTime.now());
        ${fieldName}.setUpdateUserId(loginUser.getId());
        ${fieldName}Repository.save(${fieldName});
        return ok();
    }


    @Override
    public Result deleteGetById(String accessToken, ${primaryKey.columnType} ${primaryKey.changeColumnName}){
        if (!Optional.ofNullable(${primaryKey.changeColumnName}).isPresent()){
            return fail(Tips.PARAMETER_ERROR.msg);
        }
        UserInfo loginUser = beanConfig.getAccessToken(accessToken);
        Optional<${modelName}> optional = ${fieldName}Repository.findById(id);
        if(!optional.isPresent()){
            return fail(Tips.MSG_NOT.msg);
        }
        ${modelName} ${fieldName} = optional.get();
        ${fieldName}.setIsDelete(1);
        ${fieldName}.setDeleteTime(LocalDateTime.now());
        ${fieldName}.setDeleteUserId(loginUser.getId());
        return ok();
    }


    @Override
    public Result findById(String accessToken, ${primaryKey.columnType} ${primaryKey.changeColumnName}) {
        if (${primaryKey.changeColumnName} == null){
            return fail(Tips.PARAMETER_ERROR.msg);
        }
        UserInfo loginUser = beanConfig.getAccessToken(accessToken);
		Optional<${modelName}> optional = ${fieldName}Repository.findById(${primaryKey.changeColumnName});
        return optional.map(Result::ok).orElseGet(() -> fail(Tips.MSG_NOT.msg));
    }

    @Override
    public Result pageQuery(String accessToken, Integer page, Integer size, String sort, ${modelName} ${fieldName}) {
        page = page == null ? 0 : page;
		size = size == null ? 10 : size;
    	if (page>0){page--;}
        PageRequest pageable = PageRequest.of(page, size);
        if (sort !=null && "".equals(sort.trim())) {
            pageable= PageRequest.of(page,page,new Sort(Sort.Direction.DESC,sort));
        }
        Page<${modelName}> all = ${fieldName}Repository.findAll((root,criteriaQuery,criteriaBuilder)-> {
            List<Predicate> list = new ArrayList<>();
            if (${fieldName} != null) {
<#list columnClassList as columnClass>
    <#if columnClass.columnType == "String">
                if ((${fieldName}.get${columnClass.changeColumnName?cap_first}() != null) && !"".equals(${fieldName}.get${columnClass.changeColumnName?cap_first}().trim())) {
                    list.add(criteriaBuilder.like(root.get("${columnClass.changeColumnName}").as(${columnClass.columnType}.class), "%" + ${fieldName}.get${columnClass.changeColumnName?cap_first}() + "%"));
                }
    <#else>
                if (${fieldName}.get${columnClass.changeColumnName?cap_first}() != null) {
                    list.add(criteriaBuilder.equal(root.get("${columnClass.changeColumnName}").as(${columnClass.columnType}.class), ${fieldName}.get${columnClass.changeColumnName?cap_first}()));
                }
    </#if>
</#list>
            }
            return criteriaBuilder.and(list.toArray(new Predicate[list.size()]));
        }, pageable);
        Map<String, Object> map = new HashMap<>(16);
        map.put("total",all.getTotalElements());
        map.put("rows",all.getContent());
        return Result.ok(map);
    }
}

