--傀儡流儀－パペット・シャーク
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return (c:IsType(TYPE_MONSTER+TYPE_SPELL) and c:IsAbleToHand()) or (c:IsType(TYPE_TRAP) and c:IsSSetable())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<4 then return false end
		local g=Duel.GetDecktopGroup(tp,4)
		local result=g:FilterCount(s.filter,nil)>0
		return result and Duel.CheckRemoveOverlayCard(tp,1,1,1,REASON_EFFECT)
	end
	Duel.SetTargetPlayer(tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local c=e:GetHandler()
	if Duel.RemoveOverlayCard(tp,1,1,1,1,REASON_EFFECT)~=0 then
		Duel.ConfirmDecktop(p,4)
		local g=Duel.GetDecktopGroup(p,4)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_OPERATECARD)
			Duel.PreserveSelectDeckSequence(true)
			local tc=g:FilterSelect(p,s.filter,1,1,nil):GetFirst()
			Duel.PreserveSelectDeckSequence(false)
			Duel.DisableShuffleCheck(true)
			if tc:IsType(TYPE_MONSTER+TYPE_SPELL) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-p,tc)
				Duel.ShuffleHand(p)
			elseif tc:IsType(TYPE_TRAP) then
				if tc and Duel.SSet(tp,tc)~=0 then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetDescription(aux.Stringid(id,1))
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			end
		end
	end
end