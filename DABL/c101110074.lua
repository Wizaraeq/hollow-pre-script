--スプライト・ダブルクロス
function c101110074.initial_effect(c)
	--Target 1 monster on the field and GY and activate 1 effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110074,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101110074+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101110074.target)
	e1:SetOperation(c101110074.activate)
	c:RegisterEffect(e1)
end
function c101110074.lnkfilter(c)
	return c:IsType(TYPE_LINK) and c:IsLink(2)
end
function c101110074.getzones(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(c101110074.lnkfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	return bit.band(zone,0x1f)
end
function c101110074.atchfilter(c,tp)
	return (c:IsControler(tp) or c:IsLocation(LOCATION_GRAVE) or c:IsAbleToChangeControler()) and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c101110074.xyzfilter,tp,LOCATION_MZONE,0,1,c)
end
function c101110074.xyzfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsRank(2) and c:IsFaceup()
end
function c101110074.ctrlfilter(c,zone)
	return c:IsControlerCanBeChanged(false,zone)
end
function c101110074.spfilter(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c101110074.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=c101110074.getzones(tp)
	local b1=Duel.IsExistingTarget(c101110074.atchfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil,tp)
	local b2=Duel.IsExistingTarget(c101110074.ctrlfilter,tp,0,LOCATION_MZONE,1,nil,zone)
	local b3=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c101110074.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,zone)
	if chkc then
		local label=e:GetLabel()
		if label==1 then
			return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c101110074.atchfilter(chkc,tp)
		elseif label==2 then
			return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c101110074.ctrlfilter(chkc,zone)
		elseif label==3 then
			return chkc:IsLocation(LOCATION_GRAVE) and c101110074.spfilter(chkc,e,tp,zone)
		end
	end
	if chk==0 then return b1 or b2 or b3 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(101110074,0)
		opval[off-1]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(101110074,1)
		opval[off-1]=1
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(101110074,2)
		opval[off-1]=2
		off=off+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local sel=Duel.SelectOption(tp,table.unpack(ops))
	local op=opval[sel]
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,c101110074.atchfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil,tp)
		if g:GetFirst():IsLocation(LOCATION_GRAVE) then
			Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
		end
	elseif op==1 then
		e:SetCategory(CATEGORY_CONTROL)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectTarget(tp,c101110074.ctrlfilter,tp,0,LOCATION_MZONE,1,1,nil,zone)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c101110074.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,zone)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
	end
end
function c101110074.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local zone=c101110074.getzones(tp)
	local op=e:GetLabel()
	if op==0 then
		if not tc:IsImmuneToEffect(e) and Duel.IsExistingMatchingCard(c101110074.xyzfilter,tp,LOCATION_MZONE,0,1,tc) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local xc=Duel.SelectMatchingCard(tp,c101110074.xyzfilter,tp,LOCATION_MZONE,0,1,1,tc):GetFirst()
			if xc then
				Duel.Overlay(xc,tc,true)
			end
		end
	elseif op==1 then
		if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
			Duel.GetControl(tc,tp,0,0,zone)
		end
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and zone>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	end
end