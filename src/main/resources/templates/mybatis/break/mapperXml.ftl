<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="${mappers}.${modelName}Mapper">
    <insert id="insertSelectiveCustom" useGeneratedKeys="true" keyProperty="id" parameterType="${packageName}.${entity}.${modelName}">
        insert into ${tableName}
        <selectKey keyProperty="id" order="AFTER" resultType="java.lang.Integer">
                    select @@IDENTITY AS ID
        </selectKey>
        <trim prefix="(" suffix=")" suffixOverrides=",">
<#if columnClassList ??>
    <#list columnClassList as column>
        <if test="${column.changeColumnName} != null">
            ${column.columnName},
        </if>
    </#list>
</#if>
        </trim>
        <trim prefix="values (" suffix=")" suffixOverrides=",">
<#if columnClassList ??>
    <#list columnClassList as column>
        <if test="${column.changeColumnName} != null">
            ${'#'}{${column.changeColumnName}},
        </if>
    </#list>
</#if>

        </trim>
    </insert>
</mapper>