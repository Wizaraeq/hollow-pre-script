--選律のヴァルモニカ
function c100421040.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100421040,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,100421040+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100421040.condition)
	e1:SetTarget(c100421040.target)
	e1:SetOperation(c100421040.activate)
	c:RegisterEffect(e1)
end
function c100421040.cfilter(c)
	return c:IsSetCard(0x2a3) and c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER
end
function c100421040.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100421040.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c100421040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c100421040.linkfilter(c)
	return c:IsSetCard(0x2a3) and c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c100421040.activate(e,tp,eg,ep,ev,re,r,rp,ex)
	local op=nil
	if ex then
		op=ex
	else
		local both=Duel.IsExistingMatchingCard(c100421040.linkfilter,tp,LOCATION_MZONE,0,1,nil)
		if both then
			op=Duel.SelectOption(tp,aux.Stringid(100421040,1),aux.Stringid(100421040,2),aux.Stringid(100421040,3))+1
		else
			op=Duel.SelectOption(tp,aux.Stringid(100421040,1),aux.Stringid(100421040,2))+1
		end
	end
	local break_chk=nil
	local c=e:GetHandler()
	if op==1 or op==3 then
		--Gain 500 LP and apply the targeting procetion effect
		if Duel.Recover(tp,500,REASON_EFFECT)>0 and Duel.GetFlagEffect(tp,100421040)==0 then
			break_chk=true
			Duel.RegisterFlagEffect(tp,100421040,RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e1:SetTargetRange(LOCATION_ONFIELD,0)
			e1:SetTarget(c100421040.cttg)
			e1:SetValue(aux.tgoval)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
	if op==2 or op==3 then
		local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
		if break_chk then Duel.BreakEffect() end
		if Duel.Damage(tp,500,REASON_EFFECT)>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(100421040,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
			local nc=g:Select(tp,1,1,nil)
			local tc=nc:GetFirst()
			Duel.HintSelection(nc)
			Duel.BreakEffect()
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	end
end
function c100421040.cttg(e,c)
	return c:IsSetCard(0x2a3) and c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER
end