--ライゼオル・ホールスラスター
local s,id,o=GetID()
function s.initial_effect(c)
	--Destroy face-up cards your opponent controls up to the number of "Raizeol" Xyz monsters you control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--Xyz Summon using monsters you control, including a "Raizeol" monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.xyztg)
	e2:SetOperation(s.xyzop)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsSetCard(0x2bd) and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,ct,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,tp,0)
end
function s.attachfilter(c)
	return c:IsSetCard(0x2bd) and c:IsCanOverlay()
end
function s.axyzfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsRank(4) and c:IsFaceup()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=sg:Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.attachfilter),tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.axyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACH)
		local tc=Duel.SelectMatchingCard(tp,s.attachfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local xyzc=Duel.SelectMatchingCard(tp,s.axyzfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		if not xyzc:IsImmuneToEffect(e) then
			Duel.BreakEffect()
			Duel.Overlay(xyzc,tc)
		end
	end
end
function s.fselect(sg,tp)
	local mg=Duel.GetMatchingGroup(s.xfilter2,tp,LOCATION_MZONE,0,nil)
	mg:Merge(sg)
	return mg:CheckSubGroup(s.matfilter,1,#mg,tp,sg)
end
function s.matfilter(sg,tp,g)
	return Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,sg)
end
function s.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg,1,#mg)
end
function s.zfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2bd) and c:IsCanBeXyzMaterial(nil)
end
function s.xfilter2(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function s.xyzfilter2(c)
	return c:IsType(TYPE_XYZ)
end
function s.ovfilter(c,tp,sg)
	local mg=Duel.GetMatchingGroup(s.xfilter2,tp,LOCATION_MZONE,0,nil)
	mg:Merge(sg)
	return mg:CheckSubGroup(s.gselect,1,#mg,c,sg)
end
function s.gselect(sg,c,g)
	return c:IsXyzSummonable(sg,1,#sg) and sg:IsExists(Card.IsSetCard,1,nil,0x2bd)
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(s.zfilter,tp,LOCATION_MZONE,0,nil,e,tp)
	if chk==0 then return mg:CheckSubGroup(s.fselect,1,7,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.xfilter2,tp,LOCATION_MZONE,0,nil)
	local exg=Duel.GetMatchingGroup(s.xyzfilter2,tp,LOCATION_EXTRA,0,nil)
	local xyzg=exg:Filter(s.ovfilter,nil,tp,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		local fg=Duel.GetMatchingGroup(s.xfilter2,tp,LOCATION_MZONE,0,nil)
		local sg=fg:SelectSubGroup(tp,s.gselect,false,1,7,xyz,g)
		Duel.XyzSummon(tp,xyz,sg)
	end
end
 