--ヴォルカニック・リムファイア
function c100428020.initial_effect(c)
	--to grave/set canon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100428020,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c100428020.optg)
	e1:SetOperation(c100428020.opop)
	c:RegisterEffect(e1)
end
function c100428020.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x32)
end
function c100428020.rmfilter(c,tp,ft)
	if c:IsLocation(LOCATION_SZONE) then ft=ft+1 end
	return ft>0 and c:IsSetCard(0xb9) and c:IsAbleToRemove() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c100428020.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp)
end
function c100428020.setfilter(c,tp)
	return c:IsSetCard(0xb9) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden() and c:CheckUniqueOnField(tp)		
end
function c100428020.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local b1=Duel.GetFlagEffect(tp,100428020)==0 and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c100428020.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetFlagEffect(tp,100428020+100)==0
		and Duel.IsExistingMatchingCard(c100428020.rmfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,tp,ft)
	if chk==0 then return b1 or b2 end
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100428020,1),aux.Stringid(100428020,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(100428020,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(100428020,2))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.RegisterFlagEffect(tp,100428020,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,tp,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	elseif op==1 then
		Duel.RegisterFlagEffect(tp,100428020+100,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
	end
end
function c100428020.opop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) or Duel.Remove(c,POS_FACEUP,REASON_EFFECT)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c100428020.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	elseif op==1 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c100428020.rmfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil,tp,ft)
		if #g==0 or Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local plc=Duel.SelectMatchingCard(tp,c100428020.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		Duel.MoveToField(plc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end