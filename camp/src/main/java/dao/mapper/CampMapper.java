 package dao.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import logic.Camp;

public interface CampMapper {

	@Insert("insert ignore into campdetail "
			+ "(contentId,brazierCl,sbrsCl,posblFcltyCl,hvofBgnde,caravAcmpnyAt,toiletCo,"
			+ "swrmCo,hvofEnddle,featureNm,induty,lctCl,doNm,sigunguNm,addr1,"
			+ "tel,homepage,resveUrl,gnrlSiteCo,autoSiteCo,glampSiteCo,caravSiteCo,"
			+ "indvdlCaravSiteCo,siteBottomCl1,siteBottomCl2,siteBottomCl3,siteBottomCl4,siteBottomCl5,"
			+ "glampInnerFclty,caravInnerFclty,prmisnDe,operPdCl,operDeCl,intro,extshrCo,"
			+ "frprvtWrppCo,fireSensorCo,themaEnvrnCl,eqpmnLendCl,animalCmgCl,firstImageUrl,"
			+ "facltNm,lineIntro,bizrno,facltDivNm,mapX,mapY)"
			+ " values(#{contentId},#{brazierCl},#{sbrsCl},#{posblFcltyCl},#{hvofBgnde},#{caravAcmpnyAt},#{toiletCo},"
			+ "#{swrmCo},#{hvofEnddle},#{featureNm},#{induty},#{lctCl},#{doNm},#{sigunguNm},#{addr1},"
			+ "#{tel},#{homepage},#{resveUrl},#{gnrlSiteCo},#{autoSiteCo},#{glampSiteCo},#{caravSiteCo},"
			+ "#{indvdlCaravSiteCo},#{siteBottomCl1},#{siteBottomCl2},#{siteBottomCl3},#{siteBottomCl4},#{siteBottomCl5},"
			+ "#{glampInnerFclty},#{caravInnerFclty},#{prmisnDe},#{operPdCl},#{operDeCl},#{intro},#{extshrCo},"
			+ "#{frprvtWrppCo},#{fireSensorCo},#{themaEnvrnCl},#{eqpmnLendCl},#{animalCmgCl},#{firstImageUrl},"
			+ "#{facltNm},#{lineIntro},#{bizrno},#{facltDivNm},#{mapX},#{mapY})")
	void insert(Camp camp);

	@Select("<script> "
			+ "select * from campdetail where doNm like '%${si}%' and sigunguNm like '%${gu}%' "
			+ " and lctCl regexp #{loc} "
			+ " and induty like '%${csite}%'"
			+ " <if test='bot != null '> and ${bot} != '0' </if> "
			+ " <if test='operlist1 != null '> and facltDivNm REGEXP #{operlist1} </if> "
			+ " <if test='themelist1 != null '> and themaEnvrnCl REGEXP #{themelist1} </if> "
			+ " <if test='addlist1 != null '> and sbrsCl REGEXP #{addlist1} </if>"
			+ " <if test='carav != null '> and caravAcmpnyAt = #{carav} </if> "
			+ " <if test='pet != null '> and animalCmgCl like '${pet}%' </if>"
			+ " <if test='sort == test'> order by cnt desc </if>"
//			+ " <if test='#{oper1}!= null'> and (facltDivNm like '%${oper1}%'"
//			+ " <if test='#{oper2}!= null'> or facltDivNm like '%${oper2}%'</if>"
//			+ " <if test='#{oper3}!= null'> or facltDivNm like '%${oper3}%'</if>"
//			+ " <if test='#{oper4}!= null'> or facltDivNm like '%${oper4}%'</if>"
//			+ " <if test='#{oper5}!= null'> or facltDivNm like '%${oper5}%'</if>"
//			+ ")</if>"
			+ " limit #{startrow}, #{limit}"
			+ " </script>")
	List<Camp> list(Map<String, Object> param2);

	@Select("<script> "
			+ "select count(*) from campdetail where doNm like '%${si}%' and sigunguNm like '%${gu}%'"
			+ " and lctCl regexp #{loc} "
			+ " and induty like '%${csite}%'"
			+ " <if test='bot != null '> and ${bot} != '0' </if> "
			+ " <if test='operlist1 != null '> and facltDivNm REGEXP #{operlist1} </if> "
			+ " <if test='themelist1 != null '> and themaEnvrnCl REGEXP #{themelist1} </if> "
			+ " <if test='addlist1 != null '> and sbrsCl REGEXP #{addlist1} </if>"
			+ " <if test='carav != null '> and caravAcmpnyAt = #{carav} </if> "
			+ " <if test='pet != null '> and animalCmgCl like '${pet}%' </if>"
			+ " </script>")
	int count(Map<String, Object> param2);

	@Select("<script>"
			+ "select * from campdetail where themaEnvrnCl regexp #{themelist2} "
			+ " and posblFcltyCl regexp #{aroundlist2} "
			+ " <if test ='pet != null'> and animalCmgCl like '${pet}%' </if>"
			+ " <if test ='sort == test'> order by cnt desc </if>"
			+ " limit #{startrow},#{limit}"
			+ "</script>")
	List<Camp> list2(Map<String, Object> param);

	@Select("<script>"
			+ "select count(*) from campdetail where themaEnvrnCl regexp #{themelist} "
			+ " and posblFcltyCl regexp #{aroundlist} "
			+ " <if test ='pet != null'> and animalCmgCl like '${pet}%' </if>"
			+ "</script>")
	int count2(@Param("themelist") String themelist,@Param("pet") String pet, @Param("aroundlist") String aroundlist);

	@Select("select * from campdetail where contentId = #{value}")
	Camp selectOne(int contentId);

	@Update("update campdetail set cnt = ifnull(cnt,0)+1 where contentId =#{value}")
	void addcnt(int contentId);

	@Select("<script>"
			+ " SELECT * FROM campdetail t1 left outer JOIN"
			+ " (SELECT goodno,ifnull(count(*),0) cnt FROM good WHERE goodtype=3 group by goodno) t2 "
			+ " on t1.contentId = t2.goodno "
			+ " where t1.doNm like '%${si}%' and t1.sigunguNm like '%${gu}%' "
			+ " and t1.lctCl regexp #{loc} and t1.induty like '%${csite}%' "
			+ " <if test='bot != null '> and ${bot} != '0' </if> "
			+ " <if test='operlist1 != null '> and t1.facltDivNm REGEXP #{operlist1} </if> "
			+ " <if test='themelist1 != null '> and t1.themaEnvrnCl REGEXP #{themelist1} </if> "
			+ " <if test='addlist1 != null '> and t1.sbrsCl REGEXP #{addlist1} </if>"
			+ " <if test='carav != null '> and t1.caravAcmpnyAt = #{carav} </if> "
			+ " <if test='pet != null '> and t1.animalCmgCl like '${pet}%' </if>"
			+ " order by t2.cnt desc "
			+ "limit #{startrow},#{limit}"
			+ " </script>")
	List<Camp> lovelist(Map<String, Object> param);

	@Select("<script>"
			+ "select * from campdetail t1 left outer join "
			+ " (SELECT goodno,ifnull(count(*),0) cnt FROM good WHERE goodtype=3 group by goodno) t2 "
			+ " on t1.contentId = t2.goodno "
			+ " where t1.themaEnvrnCl regexp #{themelist2} "
			+ " and t1.posblFcltyCl regexp #{aroundlist2} "
			+ " <if test ='pet != null'> and t1.animalCmgCl like '${pet}%' </if>"
			+ " order by t2.cnt desc"
			+ " limit #{startrow},#{limit}"
			+ "</script>")
	List<Camp> lovelist2(Map<String, Object> param);

	@Select("select * from campdetail where contentId = #{value}")
	Camp mpllist(int goodno);

	@Select("select * from campdetail t1 left outer join "
			+ " (SELECT goodno,ifnull(count(*),0) cnt FROM good WHERE goodtype=3 group by goodno) t2 "
			+ " on t1.contentId = t2.goodno order by t2.cnt desc limit 0,3")
	List<Camp> maincamp();

	@Update("update campdetail set addr1=#{addr1} ,tel=#{tel} , lctCl=#{lctCl} ,facltDivNm=#{facltDivNm}, "
			+ " induty=#{induty}, operPdCl=#{operPdCl}, operDeCl=#{operDeCl}, homepage=#{homepage} where contentId=#{contentId}")
	void update(Camp camp);

//	@Select("<script>"
//			+ "select * from campdetail where themaEnvrnCl regexp #{themelist} "
//			+ " and posblFcltyCl regexp #{aroundlist} "
//			+ " <if test ='pet != null'> and animalCmgCl like '${pet}%' </if>"
//			+ " limit 0,10"
//			+ "</script>")
//	List<Camp> list2(Map<String, Object> param);


}
