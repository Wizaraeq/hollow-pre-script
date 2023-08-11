--律導のヴァルモニカ
function c100421039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100421039,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,100421039+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100421039.condition)
	e1:SetTarget(c100421039.target)
	e1:SetOperation(c100421039.activate)
	c:RegisterEffect(e1)
end
function c100421039.cfilter(c)
	return c:IsSetCard(0x2a3) and c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER
end
function c100421039.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100421039.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c100421039.target(e,tp,eg,ep,ev,re,r,rp,chk,_,angle_or_delvin)
	if chk==0 then return true end
end
function c100421039.linkfilter(c)
	return c:IsSetCard(0x2a3) and c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c100421039.activate(e,tp,eg,ep,ev,re,r,rp,ex)
	local op=nil
	if ex then
		op=ex
	else
		local both=Duel.IsExistingMatchingCard(c100421039.linkfilter,tp,LOCATION_MZONE,0,1,nil)
		if both then
			op=Duel.SelectOption(tp,aux.Stringid(100421039,1),aux.Stringid(100421039,2),aux.Stringid(100421039,3))+1
		else
			op=Duel.SelectOption(tp,aux.Stringid(100421039,1),aux.Stringid(100421039,2))+1
		end
	end
	local break_chk=nil
	if op==1 or op==3 then
		local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),TYPE_SPELL+TYPE_TRAP)
		if Duel.Recover(tp,500,REASON_EFFECT)>0 and #g1>0 and Duel.SelectYesNo(tp,aux.Stringid(100421039,4)) then
			break_chk=true
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g1:Select(tp,1,1,nil)
			Duel.HintSelection(dg)
			Duel.BreakEffect()
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
	if op==2 or op==3 then
		local g2=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if break_chk then Duel.BreakEffect() end
		if Duel.Damage(tp,500,REASON_EFFECT)>0 and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(100421039,5)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local hg=g2:Select(tp,1,1,nil)
			Duel.HintSelection(hg)
			Duel.BreakEffect()
			Duel.SendtoHand(hg,nil,REASON_EFFECT)
		end
	end
end