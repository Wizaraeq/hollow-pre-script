--ヴァルモニカ・イントナーレ
function c100421038.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100421038,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100421038,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100421038.target)
	e1:SetOperation(c100421038.activate)
	c:RegisterEffect(e1)
end
function c100421038.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c100421038.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100421038.thfilter(c)
	return c:IsLevel(4) and c:IsAbleToHand()
end
function c100421038.activate(e,tp,eg,ep,ev,re,r,rp,ex)
	local op=nil
	if ex then
		op=ex
	else
		local sel_player=Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,nil,0x2a3) and tp or 1-tp
		op=Duel.SelectOption(sel_player,aux.Stringid(100421038,1),aux.Stringid(100421038,2))+1
	end
	if op==1 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100421038.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		if Duel.Recover(tp,500,REASON_EFFECT)>0 and #g>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==2 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100421038.thfilter),tp,LOCATION_GRAVE,0,nil)
		if Duel.Damage(tp,500,REASON_EFFECT)>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(100421038,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local hg=g:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoHand(hg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,hg)
		end
	end
end