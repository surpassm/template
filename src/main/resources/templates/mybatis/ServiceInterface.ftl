package ${packageName}.${service};

import ${packageName}.${entity}.${modelName};

import java.util.List;

/**
 * @description ${comment}实体接口
 * @createDate ${.now?string("yyyy-MM-dd HH:mm:ss")}
 * @version 1.0
 * @author mc
 */
public interface ${modelName}Service {
    /**
	 * 新增
	 * @param ${fieldName} 对象
	 * @return 前端返回格式
	 */
    Result insert(${modelName} ${fieldName});
    /**
	 * 修改
	 * @param ${fieldName} 对象
	 * @return 前端返回格式
	 */
    Result update(${modelName} ${fieldName});
    /**
	 * 批量删除
	 * @param ${fieldName}List 对象
	 * @return 前端返回格式
	 */
    Result deleteInBatch(List<${modelName}> ${fieldName}List);
    /**
	 * 根据主键删除
	 * @param ${primaryKey.changeColumnName} 标识
	 * @return 前端返回格式
	 */
    Result deleteGetById(${primaryKey.columnType} ${primaryKey.changeColumnName});
    /**
	 * 根据主键查询
	 * @param ${primaryKey.changeColumnName} 标识
	 * @return 前端返回格式
	 */
    Result findOne(${primaryKey.columnType} ${primaryKey.changeColumnName});
    /**
	 * 条件分页查询
	 * @param page 当前页
	 * @param size 显示多少条
	 * @param sort 排序字段
	 * @param ${fieldName} 查询条件
	 * @return 前端返回格式
	 */
    Result pageQuery(Integer page, Integer size, String sort, ${modelName} ${fieldName});
}
