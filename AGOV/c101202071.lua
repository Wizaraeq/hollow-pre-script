--フル・アーマード・エクシーズ
function c101202071.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101202071,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCondition(c101202071.xyzcon)
	e1:SetTarget(c101202071.xyztg)
	e1:SetOperation(c101202071.xyzop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202071,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101202071.eqtg)
	e2:SetOperation(c101202071.eqop)
	c:RegisterEffect(e2)
end
function c101202071.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c101202071.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101202071.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c101202071.xyzfilter(c)
	return c:IsXyzSummonable(nil)
end
function c101202071.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101202071.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101202071.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101202071.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end
function c101202071.eqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and not c:IsForbidden()
end
function c101202071.filter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c101202071.eqfilter,tp,LOCATION_MZONE,0,1,c)
end
function c101202071.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101202071.filter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c101202071.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101202071.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_MZONE)
end
function c101202071.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local eq=Duel.SelectMatchingCard(tp,c101202071.eqfilter,tp,LOCATION_MZONE,0,1,1,tc):GetFirst()
		if eq and Duel.Equip(tp,eq,tc) then
			local c=e:GetHandler()
			--Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetLabelObject(tc)
			e1:SetValue(c101202071.eqlimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			eq:RegisterEffect(e1)
			--The equipped monster gains ATK equal to this card's
			local atk=eq:GetTextAttack()
			if atk<0 then atk=0 end
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(atk)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			eq:RegisterEffect(e2)
			--If the equipped monster would be destroyed by battle or card effect, destroy this card instead
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_EQUIP)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
			e3:SetValue(c101202071.desrepval)
			e3:SetReset(RESET_EVENT|RESETS_STANDARD)
			eq:RegisterEffect(e3)
		end
	end
end
function c101202071.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c101202071.desrepval(e,re,r,rp)
	return r&(REASON_BATTLE|REASON_EFFECT)~=0
end